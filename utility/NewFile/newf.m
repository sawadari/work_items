function newf(varargin)
    %NEWF - Create new files from template
    %  NEWF is designed to create new files from template files provided in
    %  the templates directory. The currently supported file types are
    %  class, enumeration, function, and script. This function is intended
    %  to provide a more robust file generation than the default provided
    %  by MATLAB
    %
    % Syntax:
    %    NEWF( newfile );
    %    NEWF( newfile, type );
    %    NEWF( ..., 'tempDir', template_dir );
    %    NEWF( ..., 'info', info );
    %
    % Description:
    %    NEWF(newfile) creates a script named |newfile| following the
    %         template in |templates/script.template| and opens it in the
    %         editor for editing.
    %    
    %    NEWF(newfile,type) creates a file, |newfile| of type |type|
    %         following the template in the |templates| directory and
    %         opens it in the editor for editing.
    %    
    %    NEWF(...,'tempDir',template_dir) uses |template_dir| instead of
    %         the default |templates| directory.
    %    
    %    NEWF(...,'info',info) uses the info struct/.mat file to populate
    %         fields in the generated file
    %
    % Inputs:
    %    newfile - String that specifies the name of the file to open - can
    %         include a fully or partially qualified path.
    %    type - Type of file to generate. Must be one of the types that
    %         are part of the fileTypes enum. Currently includes scripts,
    %         functions, specialized functions, classes, and
    %         enumerations. Default is script.
    %    template_dir - Directory containing custom template files.
    %         Default is |templates|.
    %    info - Struct or .mat file whose fields are used to populate the
    %         generated file. Thus, if |info.author=Your_Name|, anywhere
    %         |&author| appears in the template, |Your_Name| will appear in
    %         the generated file.
    %
    % Examples:
    %   Create an empty script called my_script with cell comments
    %   containing the script name, description, and authorship
    %   information:
    %         NEWF('my_script');
    %  
    %   Create a function called my_func that populates the fields using a
    %   .mat file:
    %         NEWF('my_func','f','info','my_info.mat'); 
    %  
    %
    %  See Also: 
    %     fileTypes
    %  %CUSTOM_HELP%

    in=parseInput(varargin{:});
    
    in.info.author=getenv('username');

    string  = readTemplate(in.type,in.tempDir);
    
    if ~isempty(in.info)
        string = subInfo(string,in.info);
    end
    
    %string = [string ,'%CUSTOM_HELP%'];
    
    string = strrep( string,'%','%%' );
    
    fid = fopen(in.fname,'w+');
    try
        fprintf(fid,string);
        if fid>2
            fclose(fid);
        end
    catch err
        if fid>2
            fclose(fid);
        end
        rethrow(err);
    end
    
    edit(in.fname);
    
    
    function in=parseInput(varargin)
        p = inputParser;
        p.addRequired('fname',@(x)ischar(x)&&~exist(x,'file'));
        p.addOptional('type','s',@(x)isfileType(x))
        p.addParamValue('tempDir',[fileparts(which('newf.m')),filesep,'templates'],...
            @(x)ischar(x)&&exist(x,'dir'));
        p.addParamValue('info',[],@(x)isstruct(x) || ...
            (~isempty(strfind(x,'.mat'))&&exist(x,'file')));
        
        p.parse(varargin{:});
        
        in.fname = p.Results.fname;
        in.type = fileTypes.getFT(p.Results.type);
        in.tempDir = p.Results.tempDir;
        if isstruct(p.Results.info)
            in.info = p.Results.info;
        elseif ~isempty(strfind(p.Results.info,'.mat')) && exist(p.Results.info,'file')
            in.info = load(p.Results.info);
        end
        
        [~, in.info.name, ~]  = fileparts(in.fname);
        
        if ~exist(fullfile(in.tempDir,[char(in.type),'.template']),'file')
            warning('newf:Warning',['File template %s does not exist in %s,',...
                ' using default instead.'],char(in.type),in.tempDir);
        end
        
        function tf=isfileType(x)
            ftypes = enumeration('fileTypes');
            tf=ismember(x,ftypes);
            if ~tf
                tf = ismember(fileTypes.getFT(x),ftypes);
            end
        end
        
    end
    
    function str=readTemplate(type,tempDir)
        fid1 = fopen(fullfile(tempDir,[char(type),'.template']));
        try
            line = fgetl(fid1);
            str = cell(0);
            count = 1;
            while ischar(line)
                str{count} = [line,'\n'];
                
                line = fgetl(fid1);
                count = count+1;
            end
            fclose(fid1);
        catch err
            fclose(fid1);
            rethrow(err);
        end
        str=[str{:}];
    end
    
    function str=subInfo(str,info)
        for name=fieldnames(info)'
            name = name{1}; %#ok<FXSET> -> better indexing
            str = regexprep(str,['&',name],info.(name),'preservecase');
        end
        locs = strfind(str,'&lit_name');
        if ~isempty(locs)
            str = strrep(str,'&lit_name',info.name);
        end
        locs = strfind(str,'&date');
        if ~isempty(locs)
            str = strrep(str,'&date',datestr(floor(now),'yyyy/mm/dd','local'));
        end
    end
    
end