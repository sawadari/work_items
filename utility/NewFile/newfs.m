function newfs(input1)
%% FUNCTION_NAME - 引数で指定したファイル名で、テンプレートファイルを元に新規作成されます。
%
% Syntax:  newfs(input1)
%
% Inputs:
%    input1 - 新規作成されるファイル名
%
% Outputs:
%    カレントフォルダに引数で指定したファイルが生成されます
%%
% ToolBox required: none
%
% Author: sawad
% Update: 2022/02/05

%% ------------- BEGIN CODE --------------

copyfile('template_function_en.m',input1)
edit(input1)

%------------- END OF CODE --------------
    
