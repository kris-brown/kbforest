<?xml version="1.0"?>
<!-- SPDX-License-Identifier: CC0-1.0 -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://www.jonmsterling.com/jms-005P.xml"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:beamer="http://ctan.org/pkg/beamer"
  xmlns:indenting="jonmsterling:indenting">

  <xsl:output method="text" encoding="utf-8" indent="no" doctype-public="" doctype-system="" />

  <xsl:template match="/">
    <xsl:text>\documentclass[fleqn]{beamer}</xsl:text>
    <xsl:text>\usepackage[final]{microtype}</xsl:text>
    <xsl:text>\usepackage{mathtools}</xsl:text>
    <!-- <xsl:text>\usepackage{iblock}</xsl:text> -->
    <xsl:text>\usepackage{xcolor,libertine,stmaryrd}</xsl:text>
    <xsl:text>
    \defaultfontfeatures{RawFeature={+axis={wght=350},+ss09}}
    \usepackage{fontspec}
    \setmonofont[
      Contextuals=Alternate,
      BoldFont=FiraCode-VF.ttf,
      ItalicFont=FiraCode-VF.ttf,
      Scale=0.8,
      BoldFeatures={RawFeature={+axis={wght=500}}},
      ItalicFeatures={RawFeature={+axis={wght=350,}}},
    ]{FiraCode-VF.ttf}
    </xsl:text>
    <xsl:text>\hypersetup{colorlinks=true,linkcolor={blue!30!black}}</xsl:text>
    <xsl:text>\usepackage[mode=buildmissing]{standalone}</xsl:text>
    <xsl:text>\usepackage{fancyvrb}</xsl:text>
    <xsl:text>
\usepackage{listings, listings-rust, lstfiracode}
\usepackage{mdframed}
\definecolor{light-gray}{gray}{0.96}
\lstset{
  basicstyle=\ttfamily\footnotesize,
  style=FiraCodeStyle,
  keywordstyle=\bfseries,
  commentstyle=\color{darkgray},
  texcl=false,
}
\lstdefinelanguage{HaskellMin}{
  morecomment=[l]{--} %
, keywords = {abstype,if,then,else,case,class,data,default,deriving,%
      hiding,if,in,infix,infixl,infixr,import,instance,let,module,%
      newtype,of,qualified,type,where,do} %
}
    </xsl:text>
    <xsl:text>\setlength{\parskip}{0.8\baselineskip}</xsl:text>
    <xsl:text>\setbeamertemplate{frametitle continuation}[from second][(contd.)]</xsl:text>
    <xsl:apply-templates select="/f:tree/f:frontmatter" mode="top" />
    <xsl:text>\begin{document}</xsl:text>

    <xsl:for-each select="//f:resource[f:resource-source[@type='latex']]">
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>\begin{filecontents*}[overwrite]{</xsl:text>
      <xsl:value-of select="@hash" />
      <xsl:text>.tex}</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>\documentclass[crop]{standalone}</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:value-of select="f:resource-source[@part='preamble']" />
      <xsl:text>\usepackage{newtxmath,newtxtext}</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>\begin{document}</xsl:text>
      <xsl:value-of select="f:resource-source[@part='body']" />
      <xsl:text>\end{document}</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>\end{filecontents*}</xsl:text>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:apply-templates select="/f:tree/f:backmatter/f:tree[f:frontmatter/f:title[@text='References']]" />
    <xsl:text>\frame{\titlepage}</xsl:text>
    <xsl:apply-templates select="/f:tree/f:mainmatter/f:tree" />
    <xsl:text>\nocite{*}</xsl:text>
    <xsl:text>\bibliographystyle{plain}</xsl:text>
    <xsl:text>\begin{frame}[t,allowframebreaks]\frametitle{Bibliography}\bibliography{\jobname}\end{frame}</xsl:text>
    <xsl:text>\end{document}</xsl:text>
  </xsl:template>

  <xsl:template match="/f:tree/f:backmatter/f:tree[f:frontmatter/f:title[@text='References']]">
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>\begin{filecontents*}[overwrite]{\jobname.bib}</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates select="f:mainmatter/f:tree/f:frontmatter/f:meta[@name='bibtex']" />
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>\end{filecontents*}</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="f:frontmatter" mode="top">
    <xsl:text>\title{</xsl:text>
    <xsl:apply-templates select="f:title" />
    <xsl:text>}</xsl:text>
    <xsl:text>\author{</xsl:text>
    <xsl:for-each select="f:authors/f:author">
      <xsl:value-of select="." />
      <xsl:if test="not(position()=last())">
        <xsl:text>\and{}</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
    <xsl:for-each select="f:meta[@name='institute']">
      <xsl:text>\institute{</xsl:text>
      <xsl:value-of select="." />
      <xsl:text>}</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="f:meta[@name='beamer-preamble']">
     <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="f:frontmatter" mode="frame">
    <xsl:apply-templates select="f:title" mode="frame" />
  </xsl:template>

  <xsl:template match="f:title" mode="frame">
    <xsl:text>\frametitle{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="f:tree[f:frontmatter/f:taxon[text()='Slide']]">
    <xsl:text>\begin{frame}</xsl:text>
    <xsl:apply-templates select="f:frontmatter" mode="frame" />
    <xsl:apply-templates select="f:mainmatter" />
    <xsl:text>\end{frame}</xsl:text>
  </xsl:template>
	<xsl:template match="f:tree[f:frontmatter/f:taxon[text()='Fragileslide']]">
		<xsl:text>\begin{frame}[fragile]&#xa;</xsl:text>
		<xsl:apply-templates select="f:frontmatter" mode="frame"/>
		<xsl:apply-templates select="f:mainmatter"/>
		<xsl:text>&#xa;\end{frame}&#xa;</xsl:text>
	</xsl:template>
	<xsl:template match="f:tree[f:frontmatter/f:taxon[text()='Notes']]">
		<xsl:text></xsl:text>
	</xsl:template>
	<xsl:template match="f:tree[f:frontmatter/f:taxon[text()='Hiddenslide']]">
		<xsl:text></xsl:text>
	</xsl:template>
  <xsl:template match="f:tree[f:frontmatter/f:taxon[text()='Proof']]">
    <xsl:text>\begin{proof}</xsl:text>
    <xsl:apply-templates select="f:mainmatter" />
    <xsl:text>\end{proof}</xsl:text>
  </xsl:template>

  <xsl:template match="f:tree[f:frontmatter/f:taxon[not(text()='Proof') and not(text()='Slide') and not(text()='Fragileslide') and not(text()='Notes')]]">
    <xsl:text>\begin{</xsl:text>
    <xsl:apply-templates select="f:frontmatter/f:taxon" />
    <xsl:text>}[{</xsl:text>
    <xsl:apply-templates select="f:frontmatter/f:title" />
    <xsl:text>}]</xsl:text>
    <xsl:apply-templates select="f:mainmatter" />
    <xsl:text>\end{</xsl:text>
    <xsl:apply-templates select="f:frontmatter/f:taxon" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="f:mainmatter">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="f:p">
    <xsl:text>\par{}</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="f:strong">
    <xsl:text>\textbf{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="f:code">
    <xsl:text>\colorbox{light-gray}{\lstinline{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}}</xsl:text>
  </xsl:template>

  <xsl:template match="f:figure">
    <xsl:text>\begin{figure}\centering</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{figure}</xsl:text>
  </xsl:template>

  <xsl:template match="f:figcaption">
    <xsl:text>\caption{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="html:img">
    <xsl:text>\includegraphics[width=0.5\pagewidth]{</xsl:text>
    <xsl:apply-templates select="@pdfsrc"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="beamer:pause">
    <xsl:text>\pause{}</xsl:text>
  </xsl:template>

  <xsl:template match="html:mark">
    <xsl:text>\alert{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="f:em">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="f:tex[not(@display='block')]">
    <xsl:text>\(</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\)</xsl:text>
  </xsl:template>

  <xsl:template match="f:tex[@display='block']">
    <xsl:text>\[</xsl:text>
    <xsl:apply-templates />
    <xsl:if test="parent::f:mainmatter/parent::f:tree/f:frontmatter/f:taxon[text()='Proof'] and position()=last()">
      <xsl:text>\qedhere</xsl:text>
    </xsl:if>
    <xsl:text>\]</xsl:text>
  </xsl:template>

  <xsl:template match="f:ol">
    <xsl:text>\begin{enumerate}</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{enumerate}</xsl:text>
  </xsl:template>

  <xsl:template match="f:ul">
    <xsl:text>\begin{itemize}</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{itemize}</xsl:text>
  </xsl:template>

  <xsl:template match="f:li">
    <xsl:text>\item{}</xsl:text>
    <xsl:apply-templates />
    <xsl:if test="(parent::f:ol/parent::f:mainmatter/parent::f:tree/f:frontmatter/f:taxon[text()='Proof'] or parent::f:ul/parent::f:mainmatter/parent::f:tree/f:frontmatter/f:taxon[text()='Proof']) and position()=last()">
      <xsl:text>\qedhere</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="f:pre">
    <xsl:text>\begin{Verbatim}[fontfamily=tt]&#xa;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#xa;\end{Verbatim}</xsl:text>
  </xsl:template>

  <xsl:template match="html:pre[@class]">
    <xsl:text>\begin{mdframed}[backgroundcolor=light-gray, innertopmargin=1em, innerleftmargin=1em, roundcorner=10pt, hidealllines=true]\begin{lstlisting}[language=</xsl:text>
    <xsl:value-of select="@class" />
    <xsl:text>]&#xa;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#xa;\end{lstlisting}\end{mdframed}</xsl:text>
  </xsl:template>

  <xsl:template match="f:ref[@f:taxon]">
    <xsl:value-of select="@f:taxon" />
    <xsl:text>~</xsl:text>
    <xsl:text>\ref{</xsl:text>
    <xsl:value-of select="@addr" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="f:ref[not(@f:taxon)]">
    <xsl:text>\S~\ref{</xsl:text>
    <xsl:value-of select="@addr" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="f:link[@type='local']">
    <xsl:choose>
      <xsl:when test="//f:tree/f:frontmatter[f:addr/text()=current()/@addr and not(ancestor::f:backmatter)]">
        <xsl:text>\hyperref[</xsl:text>
        <xsl:value-of select="@addr" />
        <xsl:text>]{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="/f:tree/f:backmatter/f:references/f:tree/f:frontmatter[f:addr/text()=current()/@addr]">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\hyperref[</xsl:text>
        <xsl:value-of select="@href" />
        <xsl:text>]{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="f:headline" />

  <xsl:template match="f:resource">
    <xsl:text>\begin{center}</xsl:text>
    <xsl:text>\includestandalone{</xsl:text>
    <xsl:value-of select="@hash" />
    <xsl:text>}</xsl:text>
    <xsl:text>\end{center}</xsl:text>
  </xsl:template>

  <xsl:template match="indenting:block">
    <xsl:text>\iblock{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="indenting:row">
    <xsl:text>\row{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

</xsl:stylesheet>
