<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" cdata-section-elements="HEADLINE S" />

  <xsl:template match="/Thread">
    <DOCSENT>
      <xsl:attribute name="DID">
        <xsl:value-of select="ThreadID"/>
      </xsl:attribute>
      <BODY>
        <HEADLINE>
          <S>
            <xsl:attribute name="PAR">1</xsl:attribute>
            <xsl:attribute name="RSNT">1</xsl:attribute>
            <xsl:attribute name="SNO">1</xsl:attribute>
            <xsl:value-of select="Title" />
          </S>
        </HEADLINE>
        <TEXT>
          <xsl:apply-templates select="InitPost" />
          <xsl:apply-templates select="Post" />
        </TEXT>
    </BODY>
    </DOCSENT>
  </xsl:template>

  <xsl:template match="Post | InitPost">
    <S>
      <xsl:attribute name="PAR">
          <xsl:number count="Post|InitPost" value="position() + 1" format="1" />
        </xsl:attribute>
        <xsl:attribute name="RSNT">1</xsl:attribute>
        <xsl:attribute name="SNO">
          <xsl:number count="Post|InitPost" value="position() + 1" format="1" />
        </xsl:attribute>
        <xsl:attribute name="UserID">
          <xsl:value-of select="UserID" />
        </xsl:attribute>
        <xsl:attribute name="Class">
          <xsl:value-of select="Class" />
        </xsl:attribute>

      <xsl:call-template name="join">
        <xsl:with-param name="list" select="Sentence/SText" />
        <xsl:with-param name="separator" select="' '" />
      </xsl:call-template>
    </S>
  </xsl:template>



  <xsl:template name="join">
    <xsl:param name="list" />
    <xsl:param name="separator" />

    <xsl:for-each select="$list">
      <xsl:value-of select="." />
      <xsl:if test="position() != last()">
        <xsl:value-of select="$separator" />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

