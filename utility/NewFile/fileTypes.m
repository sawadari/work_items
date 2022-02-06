classdef fileTypes
    %FILETYPES Enumeration of supported file types for the newf.m function
    %   This enum corresponds to the list of supported file types that
    %   newf.m can generate, based on the template files in the templates
    %   directory. It also provides on static method, getFT(name), which
    %   essentially does the reverse of char(fileTypes.XXX), while
    %   including a few abbreviations (like f, fun, and func for function).
    %
    %   SEE ALSO:
    %       newf 
    
    enumeration
        func
        class
        script
        enum
        ifunc
    end
    methods
        
        function str=char(enum)
            switch enum
                case fileTypes.func
                    str='function';
                case fileTypes.class
                    str='class';
                case fileTypes.script
                    str='script';
                case fileTypes.enum
                    str='enumeration';
                case fileTypes.ifunc
                    str='infunction';
                otherwise
                    error('Invalid fileType: %s',enum);
            end
        end
    end
    methods (Static)
        function ft = getFT(name)
            switch name
                case {'f','fun','func','function'}
                    ft = fileTypes.func;
                case {'c','cla','class'}
                    ft = fileTypes.class;
                case {'s','scr','script'}
                    ft = fileTypes.script;
                case {'e','enu','enum','enumeration'}
                    ft = fileTypes.enum;
                case {'i','ifu','ifunc','ifunction','infunction'}
                    ft = fileTypes.ifunc;
                otherwise
                    ft = [];
                    warning('NewFile:BadEnum',[name,' is not a valid file type.']);
            end
        end 
    end
    
end

