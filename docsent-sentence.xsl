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
    <xsl:for-each select="Sentence">
      <S>
        <xsl:attribute name="PAR">
          <xsl:value-of select="count(../preceding-sibling::*)" />
        </xsl:attribute>
        <xsl:attribute name="RSNT">
           <xsl:number count="Sentence" format="1" />
        </xsl:attribute>
        <xsl:attribute name="SNO">
          <xsl:value-of select="SID + 1"/>
        </xsl:attribute>
        <xsl:value-of select="SText" />
      </S>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
