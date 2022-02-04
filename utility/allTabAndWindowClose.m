function allTabAndWindowClose()
%% 説明
% モデル内のタブおよびブロックのウィンドウを全て閉じます。
%%
    block_list = find_system(bdroot);
    
    for i = 2:size(block_list, 1)
        close_system(block_list{i, 1});
    end
end