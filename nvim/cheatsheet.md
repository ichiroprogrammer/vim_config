# My CheatSheet

## original command
* [NextFile](#NextFile)
* [MultiHl](#MultiHl)
* [GitDiff](#GitDiff)
* [Grep](#Grep)
* [Launch](#Launch)
* [Term](#Term)
* [TermDbg](#TermDbg)
* [Session](#Session)
* [PathSet](#PathSet)
* [Buff](#Buff)
* [WPaste](#WPaste)
* [Cd](#Cd)

### NextFile <a id="NextFile">
xxx.cpp xxx.h xxx_ut.cppのファイルを移動する。

    <Q>        現在のファイル名を@qに代入(大文字のQ)。
    <W>        @qの中身をファイルとして開く。
    <Num><C-q> 現在のファイル名を<Num>文字消して、"その文字列.\*"とマッチしたファイルを開く。
               Numが省略された場合<Num>は0として処理する。
               Numが0であった場合、"サフィックスを削除した文字列.\*"とマッチしたファイルを開く

### MultiHl <a id="MultiHl">
複数個のターゲットをハイライトする。

    :MultiHlAdd     現在のカーソルの下のwordを'\<word\>にして、@/に追加。
    :MultiHlAddR    現在のカーソルの下のwordをそのまま@/に追加。
    :MultiHlAddI    <WORD> WORDをそのまま@/に追加。
    :MultiHlClear   @/に""を入力。

### GitDiffSession <a id="GitDiff">
git diffを使いやすくする。

    :GitDiffSession         : GitDiffSessionの開始
    :GitDiffSessionResize   : 画面をリサイズして、GitDiffSession開始
    :GitDiffSessionOff      : GitDiffSession終了
    :GitDiff <SH1>          : カレントファイルのSH1とのdiff表示
                              SH1は、:0   : ステージされたファイル(デフォルト)
                                     HEAD : HEAD
                                     コミットハッシュ

    GitDiffSessionでの"GIT DIFF"バッファ内でのノーマルコマンド
        {Visual}a       : git add from '< to '>
        c"              : git commit -m "までコマンドラインに入力
        d               : 水平分割diff表示
        vd              : 垂直分割diff表示
        h               : HEADとの水平分割diff表示
        vh              : HEADとの垂直分割diff表示
        <C-Q>           : git diffモード終了
        {Visual}L       : cygstart/wslstart from '< to '>
        {Visual}r       : git reset from '< to '>
        s               : diffリストの再ロード


### Grep <a id="Grep">
vimのgrepはイマイチなので、使いやすいGrep。

    :Grep [suffix ...]          : grep -R --include=\*.suffix ... @/
    :GrepP pattern [suffix ...] : grep -R --include=\*.suffix ... pattern

* @/は現在vimが検索対象としている正規表現で、通常ハイライトされている。
* suffixを省略した場合、cpp c h rb py vimがsuffixになる。
* 全体をgrepしたい場合は - を指定する。
* :Grep、:Grepp実行後はquick fixウインドが開いて結果を見ることができる。
* <C-g><C-n>で次へ移動、<C-g><C-p>で前に移動できる。
* :set ignorecaseが行われていた場合には、grepのオプションに-iが追加される。

### launch <a id="Launch">
wslstartやcygstartを使用して、ファイルを開く。

    :LaunchBegin dir : Launchするファイル一式をリストする。リスト対象はディレクトリである前提。
    :LaunchEnd       : LaunchBeginで開いたバッファを廃棄する。
    :LaunchFile      : LaunchBeginで開いたバッファのカレント行をwslstart or cygstartする。
    :Launch          : カレントファイルのパスをwslstart or cygstartする。

### Term <a id="Term">
:termを使うたびに新しいシェルが立ち上がり、前のシェルバッファを探すのが面倒なので、
それを回避する。

    :Term           : 特定のバッファidで:termでターミナルを開く。

    <C-q>           ターミナルをvimモードに移行。
    a, iなど        vimモードのターミナルをterminalモードに移行。

### TermDbg <a id="TermDbg">
nvimからtermdebugを便利に使う。

    :DbgStart <prog>    termdebugをロードして、gdb <prog>
    :DbgKey             下記mapをバッファローカルでmap

    オリジナルコマンド  map
    :Run [args]         R   [args] または以前の引数でプログラムを実行する
    :Arguments              {args}  次の :Run のために引数を設定する
    :Break              B   カーソル位置にブレークポイントを設定する。
    :Clear              D   カーソル位置のブレークポイントを削除する
    :Step               S   gdb の "step" コマンドを実行する
    :Over               N   gdb の "next" コマンドを実行する
    :Finish             F   gdb の "finish" コマンドを実行する
    :Continue           C   gdb の "continue" コマンドを実行する
    :Stop                   プログラムを中断する

### Session <a id="Session">
gitと連動して、pathの設定やmksessionを使う。

    :SessionBegin       Session.vimをsourceして、path、tabsをセットする。
    :SessionDir         現在のセッションが使用しているgitリポジトリのトップディレクトリを表示。
    :SessionMake        Session.vimを作る。
    :SessionNew         現在のセッションをカレントディレクトリを含むgitリポジトリにする。
    :SessionPath        パスをセットする。

### PathSet<a id="PathSet">.
pathにカレントディレクトリ以下のディレクトリをセットする。

    :PathAdd            pathにディレクトリを追加する
    :PathClear          pathを./のみにする
    :PathSet            PathClearしてからPathAddする

### Buff <a id="Buff">
軽いのが取り柄のバッファエクスプローラ。

    :Buff               :buffersの情報からBuffers問う名前のバッファを開く。
    o                   プロンプトの下のバッファを開く。
    d                   プロンプトの下のバッファをスワイプアウトする。
    D                   プロンプトの下のバッファを強制スワイプアウトする。

### WPaste <a id="WPaste">
WSLのvimから使う前提で、windowsのクリップボードにコピーする。

    :[range]WPaste      :visualモードで選択した行をwindowsのクリップボードにコピーする。
    :WPaste0            :@0をwindowsのクリップボードにコピーする。

windowsのクリップボードは\<W-V>で履歴を選択できるため、
@0 -> :WPasteを繰り返してクリップボードにコピーした後、
windowsに戻り、\<W-V>で他のアプリにペーストできる。

### Cd <a id="Cd">
vimのカレントディレクトリとshellのカレントディレクトリを同じにする。

shellを開いたwindows上で、

    <S-c>       shellのカレントディレクトリをvimのカレントディレクトリに変更する。
    <C-c>       vimのカレントディレクトリをshellのカレントディレクトリに変更する。

---
## dein(パッケージ管理)
* https://github.com/Shougo/dein.vimからdeinとダウンロードしてセットアップ
    * curl ... > installer.sh   # インストーラのダウンロード
    * sh ./installer.sh ~/$XDG_CONFIG_HOME/nvim_pkg/dein    # deinのダウンロード
* :call dein#install()			# 他のパッケージインストール

---
## 備忘録
### terminal(windows app)操作
    Alt-space -> x    最大化
    Alt-space -> r    元のサイズに戻す
    Alt-space -> n    最小化
    Alt-space -> m    ウィンドウの移動
    Alt-space -> s    ウィンドウのサイズ変更
    window-m          全アプリの最小化
    window-d          デスクトップの表示/全アプリの表示


### 正規表現
正規表現アトムについては、[ここ](https://vim-jp.org/vimdoc-ja/pattern.html#pattern-atoms)

    \_.   改行含むすべての文字にマッチ

### vimのコマンド
    :echo $MYGVIMRC         現在のrcフィルの確認
    :verbose map \<C-Q>     マップの定義位置
    :let @a=execute('scriptnames')      scriptnamesの出力をレジスタaに入れる。
    :global/^</normal AHEHE     "先頭が"<"である行の末尾に"HEHE"を追加する(Aコマンド)。


コマンドの繰り返し数の注意

    :map <C-A>  3w

とした場合、 

    2<C-A>

は
    23w

となるため、このコマンドは23ワードの移動になるが、それはおそらく意図したものではない。
\<Num>\<C-A>を\<C-A>の\<Num>回の繰り返しにしたい場合、式レジスタを使い以下のように書く。

    :map <C-A>  @='3w'<CR>

---
### to lean
    Q_ss          挿入モードでの特殊キー

    i_CTRL-V      CTRL-V {char}..   指定の{char}、もしくは10進数指定のバイト値
                                      を挿入
    i_<NL>        <NL> or <CR> or CTRL-M or CTRL-J
                                      改行して、新しい行を作成
    i_CTRL-E      CTRL-E            カーソル位置の直下の行の内容を１文字挿入
    i_CTRL-Y      CTRL-Y            カーソル位置の真上の行の内容を１文字挿入

    i_CTRL-A      CTRL-A            直前に挿入した文字列をもう一度挿入
    i_CTRL-@      CTRL-@            直前に挿入した文字列をもう一度挿入し、挿入
                                      モードから復帰
    i_CTRL-R      CTRL-R {register} 指定のレジスタの内容を挿入

    i_CTRL-N      CTRL-N            カーソルの前にあるキーワードと合致する単語
                                      を順方向に検索して挿入
    i_CTRL-P      CTRL-P            カーソルの前にあるキーワードと合致する単語
                                      を逆方向に検索して挿入
    i_CTRL-X      CTRL-X ...        カーソルの前にある単語をいろんな方法で補完
                                      する

    i_<BS>        <BS> or CTRL-H    カーソルの前の１文字を削除
    i_<Del>       <Del>             カーソル位置の１文字を削除
    i_CTRL-W      CTRL-W            カーソル位置の１単語を削除
    i_CTRL-U      CTRL-U            現在行で入力した全部の文字を削除
    i_CTRL-T      CTRL-T            'shiftwidth' での指定分のインデントを現在行
                                      の行頭に挿入
    i_CTRL-D      CTRL-D            'shiftwidth' での指定分のインデントを現在行
                                      の行頭から削除
    i_0_CTRL-D    0 CTRL-D          現在行の全インデントを削除
    i_^_CTRL-D    ^ CTRL-D          現在行の全インデントを削除。但し、次の行の
                                      インデントには影響しない

    'autochdir'       'acd'     現在編集中のファイルのディレクトリに変更する
    'autoshelldir'    'asd'     シェルのカレントディレクトリに変更する
    'belloff'         'bo'      指定した場合にベルを鳴らさない

    'cscopequickfix'  'csqf'    cscopeの結果の表示にquickfixウィンドウを使う
    'cscoperelative'  'csre'    cscope.out のディレクトリパスをプリフィックスとし
                                て使う
    'cscopetag'       'cst'     タグコマンドでcscopeを使う
    'cscopetagorder'  'csto'    :cstagが検索する順番を決める
    'cscopeverbose'   'csverb'  cscopeデータベースに追加時にメッセージを表示

    'grepformat'      'gfm'     'grepprg' の出力の書式
    'grepprg'         'gp'      :grepで使う外部プログラム

    'operatorfunc'    'opfunc'  オペレータg@で呼ばれる関数
    'paste'                     Pasteモードに移行
    'pastetoggle'     'pt'      'paste' を切替えるキー
    'relativenumber'  'rnu'     相対行番号を表示する

    'ruler'           'ru'      ステータスラインにカーソルが位置する場所を表示する
    'rulerformat'     'ruf'     'ruler' 用のフォーマット

    'showmatch'       'sm'      括弧入力時に対応する括弧を知らせる
    'spell'                     スペルチェッキングを有効にする
    'spellcapcheck'   'spc'     スペルチェッキングを有効にする
    'spellfile'       'spf'     zgとzwが単語を保存するファイル
    'spelllang'       'spl'     スペルチェックをする言語
    'spelloptions'    'spo'     スペルチェックのオプション
    'spellsuggest'    'sps'     スペリング訂正をするのに使われるメソッド

    ga               ga           カーソル位置のASCII文字コードを10進、16進、
                                    8進で表示
    g8               g8           utf-8エンコーディング用: カーソル下の文字のバ
                                    イト列を16進で表示する
    g_CTRL-G         g CTRL-G     カーソル桁数、行数、単語数、文字数を表示

    CTRL-W_x      CTRL-W x                現在のウィンドウを次のウィンドウと
                                            入れ換え

    CTRL-W_=      CTRL-W =                全ウィンドウの高さと幅を同一に
    CTRL-W_-      CTRL-W -                現在のウィンドウの高さを減らす
    CTRL-W_+      CTRL-W +                現在のウィンドウの高さを増やす
    CTRL-W__      CTRL-W _                現在のウィンドウの高さを変更する
                                            (既定値: 可能な限り高く)

    カーソル前後の
    行を表示したい場合は "zz" コマンドを使う。
    "zt" コマンドでカーソル行を画面の 1 行目として表示できます。"zb" コマンドなら
    画面の最下段です。

    set nowrapscan

    "``" コマンドは 2 個所の間を交互にジャンプします。CTRL-Oコマンドはより古いマー
    ク(O は Older の意味です)にジャンプします。CTRL-Iはより新しいマーク(たいていの
    キーボード配列では "I" キーは "O" キーのすぐ左隣りです)にジャンプします。次の
    コマンドを例にしましょう。

    "どんな問題に関しても単純で、明解で、間違った答えがある"

    テキストオブジェクトの機能一覧は text-objects を参照してください。



---
## todo
* 言語サポート
    * gdbのpでSTLコンテナのきれいな表示がしたい。
    * rtag.vim
    * Tagbar: a class outline viewer for Vim

* そのうち調べる
    * コメントフォーマット。'formatoptions' の設定
    * 'showcmd'、'backspace'
    * 関数escape(@", '\\/')
    * packadd! matchit  「と」のマッチング
    * colorscheme evening
    * :mksession、:wviminfo、:rviminfo
    * terminal 端末通信 call/drop
    * packadd! matchit
