% jecon.bst: 経済学用 BibTeX style file.
%
% First-written:       <2002/11/03>
% Time-stamp:	       <2004-06-20 21:31:51 Shiro Takeda>
% Version 1.5
% $Id: jecon.bst,v 1.4 2004/06/20 12:32:13 st Exp $
%
% これは，飯田修さんによって作成された jpolisci.bst を経済学用に
% 武田史郎 <zbc08106@park.zero.ad.jp> が改変したものです．
% 改変には aer.bst および萩平哲さんによる
% http://www.med.osaka-u.ac.jp/pub/anes/www/latex/bibtex.html
% というページも参考にさせていただきました。
%
% 元の jpolisci.bst の著作権は飯田さんにあります．
% わたしが改変した部分の著作権はどうでもいいです．好きなように扱ってくださ
% い．
%
% オリジナルの jpolisci.bst は，
% <http://www.bol.ucla.edu/~oiida/jpolisci/> で入手することができます．
%
% コメント，要望は Shiro Takeda <zbc08106@park.zero.ad.jp> まで．
%
% 以下は元の jpolisci.bst のヘッダー部分です．
%
%%%%%% Original header.
%
% JPOLISCI: a bibliography style for papers in political sicence
%           and other fields that cite Japanese literature.
%           Vertical writing (tate-gaki) compatible.

	% Version 20000910 for JBibTeX versions 0.30 or later,
        % and pLaTeX2e or later.
	% Copyright (C) 2000, all rights reserved.
	%
	% This file was derived from jbtxbst.doc.
	%
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% jbtxbst.doc, jplain.bst, junsrt.bst, jalpha.bst, jabbrv.bst,
	% tipsj.bst, jipsj.bst, tieice.bst, jname.bst, jorsj.bst, jglsj.bst,
        % seg.bst, jpolisci.bst.
	%
	% This restriction helps ensure that all standard styles are identical.
	% The file jbtxbst.doc has the documentation for this style.
	%

        % Author:
        %
        % 飯田修 Osamu Iida
        % email: oiida@newmail.net
        % URL  : http://www.bol.ucla.edu/~oiida/jpolisci/ (in Japanese)
        %
        % Bug reports, technical suggestions and any other comments
        % will be appreciated.
        % 

        % Acknowledgement:
        %
        % The following files were referred to while creating this file:
        %
        %   jglsj.bst  (by 千葉智章 Tomoaki Chiba)
        %     Function "format.lab.name" in jpolisci.bst derived from
        %     it with small modifications only. The author appreciates it.
        %
        %   seg.bst (by Martin Karrenbach)
        %     A method for making two sorts of labels is based on this
        %     file's feats.
        %
        %   jalpha.bst (by 松井正一 Shoichi Matsui)
        %     jpolisci.bst principally owes its functionality to it.
        %
        %   藤田眞作『続 LaTeX2e 階梯・縦組編』（アジソン・ウェスレイ、1998 年）。
        %
        % Friends in BBSes at IR-web <http://pws.prserv.net/oi/ -- now
        % obsolete> and KH's Web Site <http://home.att.ne.jp/wind/polisci/>
        % gave me titles of Japanese political science journals which are
        % included in MACROs.

        % This file is distributed with absolutely no warranty.
        % The author doesn't assume any kind of responsibility for
        % any inconvenience caused by using this file.

        % Last modified: 2000/12/05

%%%%%% Original header ends.
%
%%% メモ by Takeda

% "a" 'b := は b という変数に "a" という文字列を代入するということ。

% #0 は整数の 0、#1 は整数の 1．．．を表す。

% 関数の書式
%
% FUNCTION {name}
% { 's :=
%
% }
%
% 上は name という関数の定義。呼出し側では
%
% "hoge" name
%
% という形で指定。"hoge" という文字列が、変数 s に代入される。

ENTRY { address author booktitle chapter edition editor howpublished
  institution journal key month note number organization pages publisher
  school series title type volume year yomi jauthor jkanyaku jtitle
  jpublisher jyear }

  { is.kanji.entry field.used }

  { label cyear flabel alabel extra.label sort.label list.year }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {add.kanji.period}
{
  add.period$ duplicate$
  #-1 #1 substring$ "." =
    {#-2 global.max$ substring$ "．" *}
    'skip$
  if$
}

FUNCTION {output.nonnull}
{ 's :=
% mid.sentence のとき
  output.state mid.sentence =
    { is.kanji.entry
        { "，" * write$ }
        { ", " * write$ }
      if$
    }
% mid.sentence ではないとき
    { output.state after.block =
%       after.block のとき
	{ is.kanji.entry
            {add.kanji.period write$}
            {add.period$ write$}
	  if$
	}
%       before.all のとき
	{ output.state before.all =
	    'write$
	    { is.kanji.entry
 		{ add.kanji.period write$ }
		{ add.period$ " " * write$ }
	      if$
	    }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

% output.nonnull2 は文中でも ","、「，」を付けない。
FUNCTION {output.nonnull2}
{ 's :=
% mid.sentence のとき
  output.state mid.sentence =
    { is.kanji.entry
        { " " * write$ }
        { " " * write$ }
      if$
    }
% mid.sentence なないとき
    { output.state after.block =
%       after.block のとき
	{ is.kanji.entry
            {add.kanji.period write$}
            {add.period$ write$}
	  if$
	}
%       before.all のとき
	{ output.state before.all =
	    'write$
	    { is.kanji.entry
 		{ add.kanji.period write$ }
		{ add.period$ " " * write$ }
	      if$
	    }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output2}
{ duplicate$ empty$
    'pop$
    'output.nonnull2
  if$
}

% output.check ではエントリーが空なら warning が出力される。
FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.check2}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull2
  if$
}

% \harvarditem[Brezis et~al.]{Brezis, Krugman and
%   Tsiddon}{1993}{brezis93:_leapf_inter_compet}
% Brezis, Elise~S., Paul~R. Krugman, and Daniel Tsiddon  (1993) ``Leapfrogging in
%   International Competition: A Theory of Cycles in National Technological
%   Leadership.'', {\em American Economic Review.}, Vol.~83. No.~5. pp.
%   1211--1219.

% \harvarditem[abbreviated citation]{full citation}{year}{keyword} ...
%
% という形式で出力する。

FUNCTION {output.bibitem}
{ newline$
  "\harvarditem[" write$
  alabel write$			% alabel が abbreviated citation
  "]{" write$
  flabel write$			% flabel が full citation
  "}{" write$
  year write$			% year
  "}{" write$
  cite$ write$			% cite$ で keyword がプッシュされる。
  "}" write$

  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ is.kanji.entry
    {add.kanji.period}
    {add.period$}
  if$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { duplicate$ is.kanji.str$
	{ "『"   swap$ * "』" * }
	{ add.period$ "{\em " swap$ * "}" * }
      if$
    }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff}{ll}" format.name$ is.kanji.str$
	{s nameptr "{ff}{ll}" format.name$ 't :=}
        { nameptr #1 =
 	  {s nameptr "{vv~}{ll}{, jj}{, ff}" format.name$ 't :=}
          {s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=}
         if$
        }
      if$
      nameptr #1 >
	{ namesleft #1 >
	    { s is.kanji.str$
		{"・" * t * }
		{", " * t * }
	      if$
	    }
	    { t "others" =
 		{ s is.kanji.str$
  			{"他" * }
 			{" et~al." * }
 		  if$
 		}
 		{ s is.kanji.str$
 		    {"・" * t * }
		    { numnames #2 =
 			{" and " * t * }
 			{", and " * t * }
		      if$
		    }
 		   if$
 		}
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.names.full}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff}{ll}" format.name$ is.kanji.str$
	{s nameptr "{ff}{ll}" format.name$ 't :=}
        { nameptr #1 =
 	  {s nameptr "{vv~}{ll}{, jj}{, ff}" format.name$ 't :=}
          {s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=}
         if$
        }
      if$
      nameptr #1 >
	{ namesleft #1 >
	    { s is.kanji.str$
		{"・" * t * }
		{", " * t * }
	      if$
	    }
	    { t "others" =
 		{ s is.kanji.str$
  			{"他" * }
 			{" et~al." * }
 		  if$
 		}
 		{ s is.kanji.str$
 		    {"・" * t * }
		    { numnames #2 =
 			{" and " * t * }
 			{", and " * t * }
		      if$
		    }
 		   if$
 		}
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.editornames}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff}{ll}" format.name$ is.kanji.str$
	{s nameptr "{ff}{ll}" format.name$ 't :=}
        {s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=}
      if$
      nameptr #1 >
	{ namesleft #1 >
	    { s is.kanji.str$
		{"・" * t * }
		{", " * t * }
	      if$
	    }
	    { t "others" =
 		{ s is.kanji.str$
  			{"他" * }
 			{" et~al." * }
 		  if$
 		}
 		{ s is.kanji.str$
 		    {"・" * t * }
		    { numnames #2 =
 			{" and " * t * }
 			{", and " * t * }
		      if$
		    }
 		   if$
 		}
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { type$ "incollection" =
        { editor format.editornames }
        { editor format.names }
      if$
      editor num.names$ #1 >
	{ editor is.kanji.str$
 		{"（編）" * }
		{ add.period$ " eds." * }
	  if$
 	}
 	{ editor is.kanji.str$
 		{"（編）" * }
		{ add.period$ " ed." * }
	  if$
 	}
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title is.kanji.str$
      { "「" title * "」" * }
      { title add.period$
        "``" swap$ * "''" *
      }
     if$
    }
  if$
}

FUNCTION {format.misc.title}
{ title empty$
    { "" }
    { title is.kanji.str$
      { "『" title * "』" * }
      { title add.period$
        "``" swap$ * "''" *
      }
     if$
    }
  if$
}

% - を -- にする関数。
FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ is.kanji.str$
	  { t #1 #2 substring$ *
	    t #3 global.max$ substring$ 't :=
	  }

	  { t #1 #1 substring$ *
	    t #2 global.max$ substring$ 't :=
	  }
	  if$
	}
      if$
    }
  while$
}

FUNCTION {format.date}
{ year  empty$
    { month empty$
	{ "" }
	{ "there's a month but no year or yyear in " cite$ * warning$ }
      if$
    }
    { is.kanji.entry
% ここかぶってる。たぶんいらない。
        { extra.label empty$
            { " ("  year * extra.label * ")" * }
            { " ("  year * extra.label * ")" * }
          if$
        }
        { " ("  year * extra.label * ")" * }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { title is.kanji.str$
%     { volume is.kanji.str$
	{ "第" volume * "巻" * }
        { "Vol." volume tie.or.space.connect}
      if$
      series empty$
	'skip$
	{ series is.kanji.str$
	    { series "，" * swap$ * }
	    { " of " * series emphasize * }
	  if$
	}
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ title is.kanji.str$
% 	{ number is.kanji.str$
	    { "第" number * "号" * }
	    {"No." number tie.or.space.connect}
	  if$
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { series is.kanji.str$
	        { series "，" * swap$ * }
	        { " in " * series * }
	      if$
	    }
	  if$
	}
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { edition is.kanji.str$
 	{ "×第" edition * "版" * }
        { is.kanji.entry
	    { output.state mid.sentence =
	      { "第" edition * "版" * }
	      { "第" edition * "版" * }
              if$
	    }
	    { output.state mid.sentence =
	      { edition "l" change.case$ ". edition" * }
	      { edition "t" change.case$ ". edition" * }
              if$
	    }
	  if$
        }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

% FUNCTION {format.pages}
% { pages empty$
%     { "" }
%     { pages multi.page.check
%  	{ "pp." pages n.dashify tie.or.space.connect }
% 	{ "p." pages tie.or.space.connect }
%       if$
%     }
%   if$
% }

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages is.kanji.str$
      { pages "頁" * }
      { is.kanji.entry
        { pages multi.page.check
          { "" pages n.dashify * "頁" * }
          { "" pages * "頁" * }
         if$
        }
        { pages multi.page.check
 	  { "pp." pages n.dashify tie.or.space.connect }
	  { "p." pages tie.or.space.connect }
         if$
        }
       if$
      }
     if$
    }
  if$
}

% volume, number, page を一緒に処理する関数。
FUNCTION {format.vol.num.pages}
{ volume empty$
     {""}
     { volume is.kanji.str$
	{ is.kanji.entry
	    { "第" volume *  "巻，" * }
	    {"Vol." volume tie.or.space.connect ". " * }
	  if$
	}
	{ is.kanji.entry	
            { "第 " volume *  "巻，" * }
	    {"Vol." volume tie.or.space.connect ". " * }
	  if$
	}
      if$
     }
  if$
  number empty$
    'skip$
    { number is.kanji.str$
        { is.kanji.entry
            { "第" number * "号" * * }
            {"No." number tie.or.space.connect * }
           if$
        }
        { is.kanji.entry
           { "第 " number * "号" * * }
           {"No." number tie.or.space.connect * }
          if$
        }
      if$
      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
	{ number empty$
  	    { format.pages * }
	    { is.kanji.entry
 		{ "，" * format.pages * }
 		{ ". " * format.pages * }
	      if$
	    }
	  if$
	}
      if$
    }
  if$
}

% chapter と page を一緒に処理する関数。
FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ chapter is.kanji.str$
	    { "" }
	    { is.kanji.entry
		{"章"}
		{"ch."}
	      if$
	    }
	  if$
	}
	{ type "l" change.case$ }
      if$
      chapter empty$
        { "" * }
	{ chapter is.kanji.str$ not is.kanji.entry and
            {"第 " chapter * swap$ *}
            { chapter is.kanji.str$ is.kanji.entry and
		{"第" chapter * "章" * }
		{chapter tie.or.space.connect}
	      if$ }
         if$ }
      if$
	 
      pages empty$
	'skip$
	{ is.kanji.entry
	    { "，" * format.pages * }
	    { ", " * format.pages * }
	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" * }
    { editor empty$
 	{ booktitle is.kanji.str$
 	    { booktitle emphasize }
%   	    { "，" booktitle emphasize * }
 	    { " In " booktitle emphasize * }
 	  if$
 	}
 	{ booktitle is.kanji.str$
 	    { format.editors "" * booktitle emphasize * }
 	    { " In " format.editors * " " * booktitle emphasize * }
 	  if$
 	}
      if$
    }
  if$
}

FUNCTION {format.address}
{ address empty$
    { "" }
    { is.kanji.entry
        { address "：" * }
        { address ": " * }
      if$
    }
   if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
 	{ title is.kanji.str$
 	    { "『" journal * "』" *  }
  	    { "In {\em " journal * "\/}" * }
          if$
	}
      if$
    }
    { title is.kanji.str$
 	{ " " key * }
  	{ "In " key * }
      if$
    }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor is.kanji.str$
     {editor #1 "{ff}" format.name$ duplicate$
      empty$
 	{pop$ editor #1 "{ll}" format.name$}
 	'skip$
      if$
      }
      {editor #1 "{vv~}{ll}" format.name$}
  if$
  editor num.names$ duplicate$
  #2 >
    { editor is.kanji.str$
 	  {pop$ "他" *} {pop$ " et~al." * } if$
    }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
 	    { editor is.kanji.str$
  		{"他" *} {" et~al." * } if$
 	    }
 	    { editor is.kanji.str$
 		{
		  "，" *
 		   editor #2 "{ff}" format.name$ duplicate$
 		   empty$
 			{pop$ editor #2 "{ll}" format.name$}
 			'skip$
 		   if$
 		 *
 		}
 		{" and " * editor #2 "{vv~}{ll}" format.name$ * }
 	      if$
 	    }
	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
       title is.kanji.str$
 	{"  "} {"In "} if$
    }
    { volume is.kanji.str$
	{ volume }
	{ is.kanji.entry
	    {"第 " volume * "巻" * }
	    {"Vol." volume tie.or.space.connect " of " *  }
	  if$
	}
      if$
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { series is.kanji.str$
		{ "『" series * "』，" * swap$ * }
	        { "{\em " * series * "\/}" * }
	      if$
	    }
	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
 	    { booktitle is.kanji.str$
 		{ booktitle emphasize }
 		{"In {\em " booktitle * "\/}" * }
 	       if$
 	    }
	  if$
	}
	{ "In " key * }
      if$
    }
    { title is.kanji.str$
 	{" " format.crossref.editor * }
 	{"In " format.crossref.editor * }
      if$
    }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.in.period}
{ is.kanji.entry
    { "，" * }
    { "." * }
   if$
}

FUNCTION {format.phd}
{ is.kanji.entry
    { "博士論文，" }
    { "Ph.D. dissertation. " }
   if$
}

FUNCTION {format.hoyakusho}
{ jauthor empty$
  jkanyaku empty$
  jtitle empty$
  jpublisher empty$
  jyear empty$
  and and and and
  { "" }
  { add.period$
    jauthor empty$
      { jkanyaku empty$
          { "" * }
          { jkanyaku format.names
            "監訳" *
          }
        if$
      }
      { jauthor format.names
        "訳" *
      }
    if$
    jtitle empty$
      { "" * }
      { jtitle emphasize * }
    if$
    jpublisher empty$
      { "" * }
      { jpublisher * "，" * }
    if$
    jyear empty$
      { "" * }
      { jyear is.kanji.str$
        { jyear * "年" * }
        { "" * jyear * "年" * }
       if$
      }
    if$
    "（" swap$ * "）" *
    add.kanji.period
  }
 if$
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check2
  format.date "year"  output.check2
  format.title "title" output.check2
  crossref missing$
    { journal emphasize "journal" output.check
      format.vol.num.pages output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  note output
  fin.entry
}

FUNCTION {format.book.pages}
{ pages empty$
    { "" }
    { pages is.kanji.str$
      { pages "頁" * }
      { is.kanji.entry
        { pages "頁" * }
        { "pp. " pages *}
       if$
      }
     if$
    }
  if$
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check2 }
    { format.authors output.nonnull2
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  format.date "year"  output.check2
  format.btitle "title" output.check2
  crossref missing$
    { format.bvolume output
      format.number.series output
      address empty$
        { publisher "publisher" output.check }
        { format.address output
	  publisher "publisher" output.check2 }
      if$
    }
    { format.book.crossref output.nonnull
    }
  if$

  format.edition output
  format.book.pages output
  format.hoyakusho output
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  format.date output
  format.misc.title "title" output.check
  howpublished output
  address output
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  format.date "year"  output.check
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      format.number.series output
      format.address output
      publisher "publisher" output.check2
    }
    { format.chapter.pages "chapter and pages" output.check
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check2
  format.date "year"  output.check2
  format.title "title" output.check2
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output

      address empty$
        { publisher output }
        { format.address output
	  publisher format.in.period "publisher" output.check2 }
      if$
      format.edition output
      format.chapter.pages output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check2
  format.date "year"  output.check2
  format.title "title" output.check2
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output

      format.pages output
      address empty$
	{ organization publisher new.sentence.checkb
	  organization output
	  publisher output2
	}
	{ address output.nonnull
	  new.sentence
	  organization output
	  publisher output2
	}
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors output.nonnull }
  if$
  format.date output
  format.btitle "title" output.check
  author empty$
    { organization empty$
	{ address new.block.checka
	  address output
	}
	'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check2
  format.date "year"  output.check2
  format.title "title" output.check2
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output2
  format.date output2
  format.misc.title output2
  howpublished output
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check2
  format.date "year"  output.check2
  format.title "title" output.check2
  format.phd
  format.thesis.type output.nonnull
  school "school" output.check
  address output
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  format.date "year"  output.check
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ publisher new.sentence.checka }
	{ organization publisher new.sentence.checkb
	  organization output
	}
      if$
      publisher output2
    }
    { format.address output.nonnull
      editor empty$
	'skip$
	{ organization output }
      if$
      publisher output2
    }
  if$
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check2
  format.date "year"  output.check2
  format.title "title" output.check2
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check2
  format.date output2
  format.title "title" output.check2
  note "note" output.check
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}
MACRO {feb} {"February"}
MACRO {mar} {"March"}
MACRO {apr} {"April"}
MACRO {may} {"May"}
MACRO {jun} {"June"}
MACRO {jul} {"July"}
MACRO {aug} {"August"}
MACRO {sep} {"September"}
MACRO {oct} {"October"}
MACRO {nov} {"November"}
MACRO {dec} {"December"}

READ

FUNCTION {set.is.kanji.entry}
{
  author    field.or.null is.kanji.str$
  title     field.or.null is.kanji.str$ or
  editor    field.or.null is.kanji.str$ or
  journal   field.or.null is.kanji.str$ or
  booktitle field.or.null is.kanji.str$ or
  series    field.or.null is.kanji.str$ or
  'is.kanji.entry :=
}

ITERATE {set.is.kanji.entry}

INTEGERS { author.field editor.field organization.field title.field key.field }

FUNCTION {init.field.constants}
{ #0 'author.field :=
  #1 'editor.field :=
  #2 'organization.field :=
  #3 'title.field :=
  #4 'key.field :=
}

EXECUTE {init.field.constants}

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

INTEGERS { et.al.char.used }

FUNCTION {initialize.et.al.char.used}
{ #0 'et.al.char.used :=
}

EXECUTE {initialize.et.al.char.used}

FUNCTION {format.lab.names}
{ 's :=
   s num.names$ 'numnames :=
   numnames #2 >
	{ s is.kanji.str$
	  { s #1 "{ff}" format.name$ 't :=
		t empty$
		  { s #1 "{ll}" format.name$}
		  { s #1 "{ff}" format.name$}
		if$
 		"他" * }
	  { s #1 "{ll}" format.name$
		" et~al." * }
	  if$
	}
	{ numnames #2 =
	  { s is.kanji.str$
		{ s #1 "{ff}" format.name$ 't :=
		  t empty$
			{ s #1 "{ll}" format.name$}
			{ s #1 "{ff}" format.name$}
		  if$
		  s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
 			{"他" *}
			{ "・" *
			  s #2 "{ff}" format.name$ 't :=
			  t empty$
				{s #2 "{ll}" format.name$ *}
				{s #2 "{ff}" format.name$ *}
			  if$
			}
			if$
		}
		{ s #1 "{ll}" format.name$
		  s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
			{ " et~al." * }
			{ " and " *
			  s #2 "{ll}" format.name$ *}
			if$
		}
	    if$
	  }
	  { s is.kanji.str$
		{ s #1 "{ff}" format.name$ 't :=
		  t empty$
			{ s #1 "{ll}" format.name$}
			{ s #1 "{ff}" format.name$}
		  if$
		}
		{ s #1 "{ll}" format.name$ }
	    if$
	  }
	if$
	}
  if$
}

FUNCTION {format.lab.names.full}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
      { s is.kanji.str$
        { s nameptr "{ff}" format.name$ 't :=
	  nameptr #1 >
          { namesleft #1 >
              { "・" * t * }
              { t "others" =
                   { "他" * }
                  { "・" * t * }
                if$
              }
              if$
           }
           't
         if$
         nameptr #1 + 'nameptr :=
         namesleft #1 - 'namesleft :=
        }
        { s nameptr "{vv~}{ll}" format.name$ 't :=
          nameptr #1 >
            { namesleft #1 >
              { ", " * t * }
              { t "others" =
                  { " et~al." * }
                  { " and " * t * }
                if$
              }
              if$
           }
           't
         if$
         nameptr #1 + 'nameptr :=
         namesleft #1 - 'namesleft :=
       }
      if$
    }
  while$
  numnames #1 > #1 #2 = and {", eds" *} {} if$
  numnames #1 = #1 #2 = and {", ed" *} {} if$
%  numnames #1 > field.used editor.field = and {", eds" *} {} if$
%  numnames #1 = field.used editor.field = and {", ed" *} {} if$
}



FUNCTION {author.key.label}
{ author empty$
    { key empty$
	{ cite$ #1 #3 substring$ }
	{ key #3 text.prefix$ }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.label.full}
{ author empty$
    { key empty$
	{ cite$ #1 #3 substring$ }
	{ key #3 text.prefix$ }
      if$
    }
    { author format.lab.names.full }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
	{ key empty$
	    { cite$ #1 #3 substring$ }
	    { key #3 text.prefix$ }
	  if$
	}
	{ editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label.full}
{ author empty$
    { editor empty$
	{ key empty$
	    { cite$ #1 #3 substring$ }
	    { key #3 text.prefix$ }
	  if$
	}
	{ editor format.lab.names.full }
      if$
    }
    { author format.lab.names.full }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
	{ organization empty$
	    { cite$ #1 #3 substring$ }
	    { "The " #4 organization chop.word #3 text.prefix$ }
	  if$
	}
	{ key #3 text.prefix$ }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
	{ organization empty$
	    { cite$ #1 #3 substring$ }
	    { "The " #4 organization chop.word #3 text.prefix$ }
	  if$
	}
	{ key #3 text.prefix$ }
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.flabel}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label.full
    { type$ "proceedings" =
	'editor.key.organization.label
	{ type$ "manual" =
	    'author.key.organization.label
	    'author.key.label.full
	  if$
	}
      if$
    }
  if$
  duplicate$
  swap$ 'flabel :=
  year field.or.null * sortify 'sort.label :=
}

FUNCTION {calc.alabel}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
	'editor.key.organization.label
	{ type$ "manual" =
	    'author.key.organization.label
	    'author.key.label
	  if$
	}
      if$
    }
  if$
  duplicate$
  swap$ 'alabel :=
  year field.or.null * sortify 'sort.label :=
}

FUNCTION {sort.format.names}
{ 's :=
  yomi empty$
     'skip$
     { yomi 's := }
  if$
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ ", " * }
	'skip$
      if$
      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
 	{ s is.kanji.str$
  		{"他" * }
 		{" et~al." *}
	  if$
 	}
	{ t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
	{ "to sort, need author or key in " cite$ * warning$
	  ""
	}
	{ key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
	{ key empty$
	    { "to sort, need author, editor, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
	{ key empty$
	    { "to sort, need author, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
	{ key empty$
	    { "to sort, need editor, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {calc.label}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
	'editor.key.organization.label
	{ type$ "manual" =
	    'author.key.organization.label
	    'author.key.label
	  if$
	}
      if$
    }
  if$
  duplicate$
  is.kanji.entry
    { "、" *  year field.or.null * }
    { " " *   year field.or.null * }
  if$
  swap$ 'label :=
  year field.or.null
  *
  sortify 'sort.label :=
}

FUNCTION {presort}
{ calc.label
  is.kanji.entry
    { yomi empty$
       { sort.label }
       { yomi year field.or.null * }
      if$
      "    "
      *
    }
    { sort.label
      "    "
      *
    }
  if$
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
	'editor.organization.sort
	{ type$ "manual" =
	    'author.organization.sort
	    'author.sort
	  if$
	}
      if$
    }
  if$
  *
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {calc.flabel}
ITERATE {calc.alabel}

ITERATE {presort}

SORT

STRINGS { longest.label last.sort.label next.extra }

INTEGERS { longest.label.width last.extra.num }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.sort.label :=
  "" 'next.extra :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
}

FUNCTION {forward.pass}
{ last.sort.label sort.label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      sort.label 'last.sort.label :=
    }
  if$
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    {}
  if$
  year empty$
    { "n.d." extra.label * 'list.year := }
    { year extra.label * 'list.year := }
  if$
  extra.label 'next.extra :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION{punctuation}
{
  "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"  write$ newline$
  "%"                                                                    write$ newline$
  "%  This bbl file is created through jecon.bst"                        write$ newline$
  "%  jecon.bst is available at"                                         write$ newline$
  "%  <http://park.zero.ad.jp/~zbc08106/tex/jecon/>"                     write$ newline$
  "%"                                                                    write$ newline$
  "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"  write$ newline$
  newline$
}

EXECUTE {punctuation}

FUNCTION {begin.bib}
{ et.al.char.used
    { "\newcommand{\etalchar}[1]{$^{#1}$}" write$ newline$ }
    'skip$
  if$
  preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
%   "\ifx\undefined\bysame" write$ newline$
%   "\newcommand{\bysame}{\leavevmode\rule[.5ex]{3em}{.5pt}\ }"
%        write$ newline$
%   "\fi" write$ newline$
%   newline$
  "\begin{thebibliography}{xx}" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
