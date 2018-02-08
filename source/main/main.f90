program feconv
!-----------------------------------------------------------------------
! Utility to convert between several mesh and FE field formats
!
! Licensing: This code is distributed under the GNU GPL license.
! Author: Francisco Pena, fran(dot)pena(at)usc(dot)es
! Last update: see variable 'last_update'
!-----------------------------------------------------------------------
use basicmod, only: string, error, is_arg, args_count, get_arg
use module_feconv, only: convert
implicit none
character(10) :: last_update = '28/05/2014'


!read and store arguments
if (command_argument_count() == 0) call error('(feconv) command line arguments not found; to show help information: feconv -h')
if (is_arg('-v')) then
  !show version
  print '(a)', 'Utility to convert between several finite element mesh and field formats'
  print '(a)', 'Licensing: This code is distributed under the GNU GPL license'
  print '(a)', 'Author: Ingenieria Matematica, http://www.usc.es/ingmat/?lang=en'
  print '(a/)', 'Last update: '//last_update
  stop
elseif (is_arg('-h')) then
  !show help
  print '(a)', 'NAME'
  print '(a)', '    feconv - utility to convert between several finite element mesh and field formats'
  print '(a)', ' '
  print '(a)', 'SYNOPSIS'
  print '(a)', '    feconv -h'
  print '(a)', '    feconv -v'
  print '(a)', '    feconv -l <infile>'
  print '(a)', '    feconv [OPTIONS] <infile> <outfile>'
  print '(a)', ' '
  print '(a)', 'DESCRIPTION'
  print '(a)', '    The feconv converts the file <infile> into the file <outfile>. The format of each file is indicated by'
  print '(a)', '    its extension. Visit MESH FORMATS and FIELD FORMATS sections of this help to know the available formats.'
  print '(a)', '    Visit EXAMPLES section to see some usage examples.'
  print '(a)', ' '
  print '(a)', '    The options are as follows:'
  print '(a)', ' '
  print '(a)', '    -cm'
  print '(a)', '        Performs a bandwidth optimization using the CutHill-McKee algorithm. This option is incompatible with'
  print '(a)', '        field conversion'
  print '(a)', ' '
  print '(a)', '    -cn'
  print '(a)', '        Save every input elementwise field as a nodewise in <outfile>. If absent, elementwise fields are saved'
  print '(a)', '        unchanged when the output field format can handle them'
  print '(a)', ' '
  print '(a)', '    -es <n>, -es [<n1>,<n2>,<n3>,...]'
  print '(a)', '        Save in <outfile> a submesh extracting only elements with reference <n>. When several references'
  print '(a)', '        must be extrated, separate them with commas without blank spaces and enclose them in square brackets.'
  print '(a)', '        This option is available only for Lagrange P1 meshes'
  print '(a)', ' '
  print '(a)', '    -ff'
  print '(a)', '        When a .msh file appears, format applied is FreeFem++ MSH format; if absent, format applied is'
  print '(a)', '        ANSYS MSH format'
  print '(a)', ' '
  !print '(a)', '    -glue'
  !print '(a)', '        When transforming to MFM several pieces, identify coincident nodes from different pieces'
  !print '(a)', '        (not yet implemented)'
  !print '(a)', ' '
  print '(a)', '    -gm'
  print '(a)', '        When a .msh file appears, format applied is Gmsh MSH ASCII format; if absent, format applied is'
  print '(a)', '        ANSYS MSH format'
  print '(a)', ' '
  print '(a)', '    -h'
  print '(a)', '        Show this help and exit'
  print '(a)', ' '
  print '(a)', '    -if <file>'
  print '(a)', '        Specify the input field file <file>.  Option -if is required for field formats classified as (O)'
  print '(a)', '        and ignored otherwise. See paragraph FIELD FORMATS regarding field classification. This option is'
  print '(a)', '        incompatible with -cm'
  print '(a)', ' '
  print '(a)', '    -in <name>, -in [<name1>,<name2>,<name3>,...]'
  print '(a)', '        Specify the input field name <name> to be read. When several names are indicated, enclose everyone'
  print '(a)', '        in quotes, separate them with commas without blank spaces and enclose them in square brackets.'
  print '(a)', '        Option -in is ignored for field formats classified as (U), and it is optional otherwise.'
  print '(a)', '        In the latter case, if omitted, all the fields are read by feconv. See paragraph FIELD FORMATS '
  print '(a)', '        regarding field classification. See paragraph ANSYS INTERPOLATION FILES regarding restriccions '
  print '(a)', '        applied to ANSYS Interpolation files. Field conversion is incompatible with -cm'
  print '(a)', ' '
  !print '(a)', '    -is'
  !print '(a)', '        Input file contains P2 isoparametrical elements that must be read using Salome ordering (vertices'
  !print '(a)', '        and midpoints sandwiched)'
  !print '(a)', ' '
  print '(a)', '    -j {yes|no}'
  print '(a)', '        Either to enforce or not positive jacobian in element groups with maximal topological dimension.'
  print '(a)', '        The default value is ''yes''. Since positivity is checked using the third component of the normal vector,'
  print '(a)', '        its enforcement is not recommend for two-dimensional meshes containing almost vertical elements'
  print '(a)', ' '
  print '(a)', '    -l <infile>'
  print '(a)', '        Print to screen the content of <infile> (only scalar data is shown)'
  print '(a)', ' '
  print '(a)', '    -l1'
  print '(a)', '        Output file will contain Lagrange P1 finite elements'
  print '(a)', ' '
  print '(a)', '    -l2'
  print '(a)', '        Output file will contain Lagrange P2 finite elements'
  print '(a)', ' '
  print '(a)', '    -nd'
  print '(a)', '        Output file will contain Whitney (edge) finite elements of the lowest degree'
  print '(a)', ' '
  print '(a)', '    -of <file>'
  print '(a)', '        Specify the output field file <file>.  Option -of is mandatory for field formats classified as (O)'
  print '(a)', '        and ignored otherwise. See paragraph FIELD FORMATS regarding field classification. This option is'
  print '(a)', '        incompatible with -cm'
  print '(a)', ' '
  print '(a)', '    -on <name>, -on [<name1>,<name2>,<name3>,...]'
  print '(a)', '        Specify the input field name <name> to be read. When several names are indicated, enclose everyone'
  print '(a)', '        in quotes, separate them with commas without blank spaces and enclose them in square brackets.'
  print '(a)', '        Option -on is ignored for field formats classified as (U), and it is optional otherwise.'
  print '(a)', '        In the latter case, when it appears, the number of names in -on must coincide with the number of'
  print '(a)', '        input fields read by feconv. See paragraph FIELD FORMATS regarding field classification. '
  print '(a)', '        See paragraph ANSYS INTERPOLATION FILES regarding restriccions applied to ANSYS Interpolation files.'
  print '(a)', '        This option is incompatible with -cm'
  print '(a)', ' '
  print '(a)', '    -p <n>'
  print '(a)', '        When the input mesh is divided in several pieces (like in VTU or MPHTXT formats), <n> is '
  print '(a)', '        the number of the piece to be saved. If not present, when transforming to MFM, all pieces are merged and '
  print '(a)', '        coincident nodes from different pieces are not indentified; use option -glue identify coincident nodes '
  print '(a)', '        from different pieces (not yet implemented)'
  print '(a)', ' '
  print '(a)', '    -pad <val>'
  print '(a)', '        When reading a nodewise field not defined for every node, assigns the real value <val> in those nodes;'
  print '(a)', '        similarly, when reading a elementwise field not defined for every maximum dimension element, '
  print '(a)', '        assigns the real value <val> in those elements; if absent, <val> is taken as 0.'
  print '(a)', ' '
  !print '(a)', '    -s <file> (not implemented)'
  !print '(a)', '        A series of fields must be processed; <file> is the name of an ASCII file containing '
  !print '(a)', '        two columns separated by blank spaces: for each line, the first column is a real number'
  !print '(a)', '        representing a parameter value (time, frequency, etc.); the second column is the name'
  !print '(a)', '        of the field file associated with the previous parameter'
  !print '(a)', '        (este formato podria convertirse en un fichero de texto, por ejemplo, de extension .par'
  !print '(a)', '        y servir de alternativa a los PVD-like files)'
  !print '(a)', ' '
  print '(a)', '    -r {hard|soft|sandwich}'
  print '(a)', '        Feconv assumes that nodes of a Lagrange P2 element are listed vertices first, then mid-points, '
  print '(a)', '        both counterclockwise. The default value ''hard'' check whether every element meet this order. '
  print '(a)', '        The value ''soft'' checks only the first element and assumes that the rest keep the same order; '
  print '(a)', '        this option can dramatically reduce the reordering computation time. The value ''sandwich'' assumes'
  print '(a)', '        that vertices and mid-points appear sandwiched and counterclockwise; this option must be used when'
  print '(a)', '        the Lagrange P2 mesh was created with SALOME'
  print '(a)', ' '
  print '(a)', '    -rt'
  print '(a)', '        Output file will contain Raviart-Thomas finite elements of the lowest degree'
  print '(a)', ' '
  print '(a)', '    -t <tolerance>'
  print '(a)', '        Tolerance to search mid-points in Lagrange P2 meshes. By default the value '
  print '(a)', '        of tolerance is epsilon for kind real64 (double precision in fortran 77). '
  print '(a)', '        Do not change it unless the conversion fails'
  print '(a)', ' '
  print '(a)', '    -ch [<tdim>,<old1>,<new1>,...,<oldn>,<newn>]'
  print '(a)', '        Specify the references to change in the mesh. The changes will only be applied to element groups of '
  print '(a)', '        topological dimension <tdim>. In those groups, the reference <old1> will be changed by <new1>, '
  print '(a)', '        etc., and finally <oldn> by <newn>. Be aware that new references can be changed again when '
  print '(a)', '        appear later in the list as an old reference. The values must be separated by commas without blank spaces'
  print '(a)', '        and enclose them in square brackets. Please, be aware that, if you want to change references for two '
  print '(a)', '        different topological dimensions, you must call FEconv twice.'
  print '(a)', ' '
  print '(a)', '    -v'
  print '(a)', '        Show version information and exit'
  print '(a)', ' '
  print '(a)', 'MESH FORMATS'
  print '(a)', '    The available input mesh formats are:'
  print '(a)', '        ANSYS (.msh),'
  print '(a)', '        I-Deas Universal (.unv),'
  print '(a)', '        VTK-XML Unstructured Grid (.vtu),'
  print '(a)', '        MD Nastran input file (.bdf),'
  print '(a)', '        COMSOL mesh file (.mphtxt)'
  print '(a)', '        FLUX mesh file (.pf3),'
  print '(a)', '        Modulef-like Formatted Mesh (.mfm),'
  print '(a)', '        Modulef-like Unformatted Mesh (.mum),'
  print '(a)', '        FreFem++ Tetrahedral and/or Triangular Lagrange P1 Mesh (.msh),'
  print '(a)', '        FreFem++ Tetrahedral Lagrange P1 Mesh (.mesh),'
  print '(a)', '        Gmsh MSH ASCII (.msh).'
  print '(a)', ' '
  print '(a)', '    The available output mesh formats are:'
  print '(a)', '        ANSYS (.msh),'
  print '(a)', '        I-Deas Universal (.unv),'
  print '(a)', '        VTK-XML Unstructured Grid (.vtu),'
  print '(a)', '        COMSOL mesh file (.mphtxt)'
  print '(a)', '        FLUX mesh file (.pf3),'
  print '(a)', '        Modulef-like Formatted Mesh (.mfm),'
  print '(a)', '        Modulef-like Unformatted Mesh (.mum),'
  print '(a)', '        FreFem++ Tetrahedral and/or Triangular Lagrange P1 Mesh (.msh),'
  print '(a)', '        FreFem++ Tetrahedral Lagrange P1 Mesh (.mesh).'
  print '(a)', '        Gmsh MSH ASCII (.msh).'
  print '(a)', ' '
  print '(a)', '    The finite elements inside a mesh can be transformed before saving them, with options -l1, -l2,'
  print '(a)', '    -rt, -nd, -cm. (REVISAR) Those options are ignored when some field option -if, -in, -of, -on appears.'
  print '(a)', ' '
  print '(a)', 'FIELD FORMATS '
  print '(a)', 'The field formats supported by feconv can be classified using dichotomic rules:'
  print '(a)', '    - I/O: Field format states that fields are saved INSIDE/OUTSIDE the mesh file.[1]'
  print '(a)', '    - N/U: Field format states that fields are NAMED/UNNAMED.'
  print '(a)', '    - S/1: Field format states that SEVERAL/ONLY ONE field(s) is(are) saved in the file.'
  print '(a)', '    - P/A: Field format states that PARAMETRIZED/ALONE fields can be saved.[2]'
  print '(a)', ' '
  print '(a)', '    The current available (both input and output) field formats are:'
  print '(a)', '                                            CLASSIFICATION    ASSOCIATED       OPTIONS[3] '
  print '(a)', '                                                            MESH FORMAT[1]  -IF  -IN  -OF  -ON'
  print '(a)', '        VTK-XML Unstructured Grid (.vtu),       (INSA)                       i    o    i    o'
  print '(a)', '        I-Deas Universal (.unv),                (INSP)                       i    o    i    o'
  print '(a)', '        FLUX mesh file (.pf3),                  (IN1A)                       i    o    i    o'
  print '(a)', '        FLUX field file (.dex),                 (ON1A)         .pf3          r    o    r    o'
  print '(a)', '        Modulef-like Formatted Field (.mff),    (OU1A)         .mfm          r    i    r    i'
  print '(a)', '        Modulef-like Unformatted Field (.muf),  (OU1A)         .mum          r    i    r    i'
  print '(a)', '        ANSYS interpolation file (.ip),         (ONSA)         .msh          r    o    r    o'
  print '(a)', ' '
  print '(a)', 'Notes:'
  print '(a)', '[1] When a field is saved outside (O) the mesh file, a mesh file must be specified with the default associated '
  print '(a)', '    mesh format.'
  print '(a)', '[2] A parametrized field is a field composed of several snapshots identified through "parameter" values'
  print '(a)', '    (time, frequency,...). A field format is (P) when all the snapshots and their associated parameter values'
  print '(a)', '    can be saved together in the file; it is (A) otherwise.'
  print '(a)', '[3] "r", "i", "o" means that the option is required, ignored or optional, respectively. See explanation'
  print '(a)', '    for options -if, -in, -of and -on to know more about their use.'
  print '(a)', ' '
  print '(a)', 'ANSYS INTERPOLATION FILES'
  print '(a)', 'The .ip field format can only store scalar fields. To save input vector fields into a .ip file, option -on must '
  print '(a)', 'specify as many names as components have the input fields. To save input .ip fields into a file supporting vector'
  print '(a)', 'fields, option -on must specify the names of the output fields, completed in (<n>), where <n> is the number of '
  print '(a)', 'components to be saved. See paragraph EXAMPLES to know nore about this topic.'
  print '(a)', ' '
  print '(a)', 'THE USE OF PARAMETERS FOR FIELD FORMATS (A)'
  print '(a)', 'Feconv can read/write PVD files holding the parameter values related to a series of snapshots.'
  print '(a)', 'For field formats (I..A), a standard PVD field can be provided. For example, the following PVD file can '
  print '(a)', 'be a valid input file to read fields stored in files "frame_1.pf3", "frame_2.pf3" and "frame_3.pf3 and"'
  print '(a)', 'link them to parameter values "0.11", "0.22" and "0.33":'
  print '(a)', ' '
  print '(a)', '    <?xml version="1.0"?>'
  print '(a)', '    <VTKFile type="Collection" version="0.1" byte_order="LittleEndian">'
  print '(a)', '      <Collection>'
  print '(a)', '        <DataSet timestep="0.11" group="" part="0" file="frame_1.pf3"/>'
  print '(a)', '        <DataSet timestep="0.22" group="" part="0" file="frame_2.pf3"/>'
  print '(a)', '        <DataSet timestep="0.33" group="" part="0" file="frame_3.pf3"/>'
  print '(a)', '      </Collection>'
  print '(a)', '    </VTKFile>'
  print '(a)', ' '
  print '(a)', 'For field formats (O..A), a modified PVD field can be provided, specifing the associated mesh file'
  print '(a)', 'in the "grid" attribute of mark "Collection". For example, the following PVD-like file can '
  print '(a)', 'be a valid input file to read fields stored in files "frame_1.dex", "frame_2.dex" and "frame_3.dex,'
  print '(a)', 'associated with mesh file "mesh.pf3" and link them to parameter values "0.11", "0.22" and "0.33":'
  print '(a)', ' '
  print '(a)', '    <?xml version="1.0"?>'
  print '(a)', '    <VTKFile type="Collection" version="0.1" byte_order="LittleEndian">'
  print '(a)', '      <Collection grid="mesh.pf3">'
  print '(a)', '        <DataSet timestep="0.11" group="" part="0" file="frame_1.dex"/>'
  print '(a)', '        <DataSet timestep="0.22" group="" part="0" file="frame_2.dex"/>'
  print '(a)', '        <DataSet timestep="0.33" group="" part="0" file="frame_3.dex"/>'
  print '(a)', '      </Collection>'
  print '(a)', '    </VTKFile>'
  print '(a)', ' '
  print '(a)', 'Please, note that both PVD files pointing non VTK-XML files and the previous PVD-like files, are not supported'
  print '(a)', 'by commercial VTK viewers.'
  print '(a)', ' '
  print '(a)', 'NAME RULES'
  print '(a)', '    Filenames must follow the usual name rules. Additionally,'
  print '(a)', '        - Filenames cannot contain blank spaces or any of the following characters: < > : """ / | ? *'
  print '(a)', '        - In order to allow full pathnames, filenames cannot contain a folder separator: "/" in GNU/Linux and OS X,'
  print '(a)', '        "\" in MS Windows.'
  print '(a)', '        - If any of the forbidden characters appear in an output filename, they will be replaced  by "X".'
  print '(a)', ' '
  print '(a)', 'EXAMPLES'
  print '(a)', '    To convert an ANSYS file into a VTU file:'
  print '(a)', ' '
  print '(a)', '       feconv file1.msh file2.vtu'
  print '(a)', ' '
  print '(a)', '    To transform a MD Nastran input file into Whitney (edge) MFM file performing Cuthill-McKee optimization:'
  print '(a)', ' '
  print '(a)', '       feconv -nd -cm file1.bdf file2.mfm'
  print '(a)', ' '
  print '(a)', '    To convert a MFM mesh file plus a MFF field file into a VTU (mesh and field) file:'
  print '(a)', ' '
  print '(a)', '       feconv -if field1.mff mesh1.mfm file2.vtu'
  print '(a)', ' '
  print '(a)', '    To convert a MSH ANSYS mesh file plus an IP field file into a VTU (mesh and field) file. Note that '
  print '(a)', '    the original scalar velocity components are saved in a vector field:'
  print '(a)', ' '
  print '(a)', '       feconv -if field1.ip -in [''pressure'',''x-velocity'',''y-velocity''] -on [''p'',''v(2)''] '//&
              &'mesh1.msh file2.vtu'
  print '(a)', ' '
  print '(a)', '    To convert a VTU (mesh and field) file into a MSH ANSYS mesh file plus an IP field file. Note that '
  print '(a)', '    the original vector field "v" is saved as scalar velocity components:'
  print '(a)', ' '
  print '(a)', '       feconv -in [''undefined'',''v(2)''] -of field2.ip -on [''uds-0'',''x-velocity'',''y-velocity''] '//&
              &'file1.vtu mesh2.msh'
  print '(a)', ' '
  print '(a)', '    For more details, please visit doc/index.xhtml'
  print '(a)', ' '
  print '(a)', 'AUTHORS'
  print '(a)', '    Written by the members of the Ingenieria Matematica research group (http://www.usc.es/ingmat/?lang=en):'
  print '(a)', '      Iban Constenla,'
  print '(a)', '      Francisco Pena,'
  print '(a)', '      Victor Sande.'
  print '(a)', '    Code related to CutHill-McKee algoritm has been adapted from the one distributed by John Burkardt'
  print '(a)', '    (http://people.sc.fsu.edu/~jburkardt/) under the GNU LGPL license.'
  print '(a)', ' '
  print '(a)', 'REPORTING BUGS'
  print '(a)', '    Report bugs to fran.pena(at)usc.es'
  print '(a)', ' '
  print '(a)', 'DOWNLOAD PAGE'
  print '(a)', '    <https://github.com/victorsndvg/FEconv>'
  print '(a)', ' '
  print '(a)', 'COPYRIGHT'
  print '(a)', '    Copyright (C) 2010 Universidade de Santiago de Compostela.  License GPLv3+: GNU GPL version 3 or later'
  print '(a)', '    <http://gnu.org/licenses/gpl.html>. This is free software: you are free to change and redistribute it.'
  print '(a)', '    There is NO WARRANTY, to the extent permitted by law.'
  print '(a)', ' '
  stop
end if

!choose converter according to arguments
call convert()

end program
