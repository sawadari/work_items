function windowFitting()
%% 説明 
% root階層および下位階層に対して最大表示(ズームフィット)にする
%%
    % root階層に対してズームフィットさせる
    set_param(bdroot,'ZoomFactor','FitSystem');
    
    % モデルの各サブシステムに対してズームフィットさせる
    syss = find_system(bdroot,'BlockType','SubSystem');
    for n = 1:length(syss)
        set_param(syss{n},'ZoomFactor','FitSystem');
    end
end