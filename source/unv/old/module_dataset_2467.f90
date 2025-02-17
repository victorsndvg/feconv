module module_dataset_2467
!-----------------------------------------------------------------------
! Module for dataset_2467 class
! Last update: 04/04/2010
!
! Name:   Permanent Groups
! Record 1:        FORMAT(8I10)
!                  Field 1       -- group number
!                  Field 2       -- active constraint set no. for group
!                  Field 3       -- active restraint set no. for group
!                  Field 4       -- active load set no. for group
!                  Field 5       -- active dof set no. for group
!                  Field 6       -- active temperature set no. for group
!                  Field 7       -- active contact set no. for group
!                  Field 8       -- number of entities in group
!
! Record 2:        FORMAT(20A2)
!                  Field 1       -- group name
!
! Record 3-N:      FORMAT(8I10)
!                  Field 1       -- entity type code
!                  Field 2       -- entity tag
!                  Field 3       -- entity node leaf id.
!                  Field 4       -- entity component/ ham id.
!                  Field 5       -- entity type code
!                  Field 6       -- entity tag
!                  Field 7       -- entity node leaf id.
!                  Field 8       -- entity component/ ham id.
!
! Repeat record 3 for all entities as defined by record 1, field 8.
! Records 1 thru n are repeated for each group in the model.
! Entity node leaf id. and the component/ ham id. are zero for all
! entities except "reference point", "reference point series"
! and "coordinate system".
!
! Example:
!
!     -1
!   2467
!         11         0         0         0         0         0         0         3
! Group_1
!          8         1         0         0         8         2         0         0
!          8         3         0         0
!     -1
!-----------------------------------------------------------------------
use module_dataset
use module_mesh_unv
use module_cells
use module_groups
implicit none

!Private procedures
private :: order, swap

contains

!***********************************************************************
! INPUT PROCEDURES
!***********************************************************************
!-----------------------------------------------------------------------
! read: read dataset 2467
! REMARK: dataset 2467 must be read after 2412
!-----------------------------------------------------------------------
subroutine read_2467(iu, m, d)
integer,                   intent(in)                 :: iu   !unit number for unvfile
type(mfm_mesh),  dimension(:), intent(inout), allocatable :: m    !meshes
integer,                   intent(in)                 :: d    !dimension
integer :: ios, Field1, F2, F3, F4, F5, F6, F7, Field8, p, j, pos, k, dm
integer, dimension(2):: etc, tag
character(len=MAXPATH) :: gname

if(.not. allocated(m)) call error('dataset_2467/read, meshes not allocated')
call alloc(groups, d+1)
call alloc(m(d)%rv, m(d)%LNV, m(d)%nl)
call alloc(m(d)%re, m(d)%LNE, m(d)%nl)
call alloc(m(d)%rf, m(d)%LNF, m(d)%nl)
call alloc(m(d)%rl, m(d)%nl);
do
  if (is_dataset_delimiter(iu, back=.true.)) exit

! Record 1
  read (unit=iu, fmt='(8I10)', iostat = ios) &
  Field1, & !group number
  F2,     & !active constraint set no. for group
  F3,     & !active restraint set no. for group
  F4,     & !active load set no. for group
  F5,     & !active dof set no. for group
  F6,     & !active temperature set no. for group
  F7,     & !active contact set no. for group
  Field8    !number of entities in group
  if (ios /= 0) call error('dataset_2467/read, #'//trim(string(ios)))
! Record 2
  read (unit=iu, fmt='(A40)', iostat = ios) gname !group name
  if (ios /= 0) call error('dataset_2467/read, #'//trim(string(ios)))
!!  read(gname, fmt=*, iostat=ios) j
!!  if (ios == 0) then
!!    print'(a,i9,a,a,a,i9)','Group number ',Field1,', named "',trim(gname), '", associated with reference number',j
!!    Field1 = j !if the group name is a number, it is used as reference
!!  else
!!    print'(a,i9,a,a,a,i9)','Group number ',Field1,', named "',trim(gname), '", associated with reference number',Field1
!!  endif
    print'(a,i9,a,a,a)','Reference number ',Field1,', associated with group named "',trim(gname),'"'
! Record 3-N
  if (Field8 == 0) then !si Field8 = 0, lectura vacia
    read (unit=iu, fmt=*, iostat = ios) (F2, p=1,Field8)
    if (ios /= 0) call error('dataset_2467/read, #'//trim(string(ios)))
  end if
  do p = 1, ceiling(Field8/2.)
    read (unit=iu, fmt='(8I10)', iostat = ios) &
    (etc(j), & !entity type code
    tag(j),  & !entity tag
    F3,      & !entity node leaf id.
    F4,      j = 1, 2 - dim(2*p, Field8)) !dim(x,y) = max(x-y, 0)
    do j = 1, 2 - dim(2*p, Field8)
      if (etc(j) == 8) then !8 => finite elements
        dm = cells(1,tag(j)); k = cells(2,tag(j)) !values for dimension dm and element k
        if (dm < d) then
          call insert(groups(dm+1), [order(m(dm)%id(1:m(dm)%LNV,k)), Field1])
        else
          call insert(groups(dm+1), [k, Field1])
        end if
      elseif (etc(j) == 7) then !7 => nodes
        call insert(groups(1), [tag(j), Field1])
      end if
    end do
  end do
end do

! CHANGE MESH REFERENCES
!vertex groups
if (groups(1)%ncells > 0) then
  do k = 1, m(d)%nl
    do j = 1, m(d)%LNV
      pos = search(groups(1), [m(d)%id(j,k)])
      if (pos > 0) m(d)%rv(j,k) = groups(1)%cell(pos,2)
    end do
  end do
end if

!edge groups
if (groups(2)%ncells > 0) then
  do k = 1, m(d)%nl
    do j = 1, m(d)%LNE
      pos = search(groups(2), order(m(d)%id(m(d)%edge(:,j),k)))
      if (pos > 0) m(d)%re(j,k) = groups(2)%cell(pos,3)
    end do
  end do
end if

!face groups
if (d == 3 .and. groups(3)%ncells > 0) then
  do k = 1, m(d)%nl
    do j = 1, m(d)%LNF
      pos = search(groups(3), order(m(d)%id(m(d)%face(:,j),k)))
      if (pos > 0) m(d)%rf(j,k) = groups(3)%cell(pos,4)
    end do
  end do
end if

!subdomain groups
if (groups(d+1)%ncells > 0) then
  m(d)%rl(groups(d+1)%cell(1:groups(d+1)%ncells,1)) = groups(d+1)%cell(1:groups(d+1)%ncells,2)
end if

end subroutine

!***********************************************************************
! PRIVATE PROCEDURES
!***********************************************************************
!-----------------------------------------------------------------------
! order: order an array (DIM <=3)
!-----------------------------------------------------------------------
function order(u) result(v)
integer, dimension(:), intent(in) :: u
integer, dimension(size(u,1)) :: v

v = u
if (size(u,1)==2 .and. v(1) > v(2)) then
  call swap(v(1), v(2))
elseif (size(u,1)==3) then
  if (v(1) > v(2)) call swap(v(1), v(2))
  if (v(2) > v(3)) call swap(v(2), v(3))
  if (v(1) > v(2)) call swap(v(1), v(2))
end if

end function

!-----------------------------------------------------------------------
! swap: swap two variables
!-----------------------------------------------------------------------
subroutine swap(u,v)
integer, intent(inout) :: u, v
integer :: tmp

tmp = u; u = v; v = tmp

end subroutine

end module

!    Permanent group entity type codes
!
!    Entity Type Code        Entity Description
!
!           1                coordinate system
!           2                data surface thickness
!           3                force on point
!           4                force on edge
!           5                traction on face
!           6                pressure on face
!           7                nodes
!           8                finite elements
!           9                dof sets, dof entities
!          10                constraint sets, coupled dofs
!          11                constraint sets, mpc equations
!          12                restraint sets, nodal displacements
!          13                restraint sets, nodal temperatures
!          14                load sets, nodal forces
!          15                load sets, nodal temperatures
!          16                load sets, nodal heat sources/sinks
!          17                load sets, face pressures
!          18                load sets, edge pressures
!          19                load sets, face heat fluxes
!          20                load sets, edge heat fluxes
!          21                load sets, face heat convections
!          22                load sets, edge heat convections
!          23                load sets, face heat radiations
!          24                load sets, edge heat radiations
!          25                load sets, element heat generations
!          26                load sets, beam temperatures
!          27                trace lines
!          28                beam force
!          29                beam distributed load
!          30                data surface
!          31                data curve
!          32                displacement on point (restraint)
!          33                displacement on edge (restraint)
!          34                displacement on surface (restraint)
!          35                temperature on point (restraint)
!          36                temperature on edge (restraint)
!          37                temperature on face (restraint)
!          38                temperature on point (temperature)
!          39                temperature on edge (temperature)
!          40                temperature on face (temperature)
!          41                heat source on point
!          42                heat flux on edge
!          43                convection on edge
!          44                radiation on edge
!          45                heat flux on face
!          46                convection on face
!          47                radiation on face
!          48                geometry contact region
!          49                fe contact region
!          50                contact pair
!          51                kinematic dof on point
!          52                kinematic dof on edge
!          53                kinematic dof on face
!          54                element definition
!          55                anchor node
!          56                edge dependancy mesh definition
!          57                fem point connector
!          58                fem area connector
!          59                vertex
!          60                edge
!          61                face
!          62                region
!          63                wireframe connector
!          64                wireframe curve
!          65                wireframe section
!          66                wireframe region
!          67                reference point
!          68                reference point series
!          69                centerpoint
