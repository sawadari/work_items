%% scopeブロックを全て閉じる

% ShowHiddenHandles の現在の設定値を取得
shh = get(0,'ShowHiddenHandles');

% on に変更
set(0,'ShowHiddenHandles','on');

% Scope ハンドルの取得
hscope = findobj(0,'Type','Figure','Tag','SIMULINK_SIMSCOPE_FIGURE');

% Scope のクローズ
close(hscope);

% ShowHiddenHandles を元の設定に戻す
set(0,'ShowHiddenHandles', shh);

