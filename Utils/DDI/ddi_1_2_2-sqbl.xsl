<?xml version="1.0" encoding="UTF-8"?>
<!--
    Document   : ddi_1_2_2-sbql.xsl
    Created on : den 5 juni 2013, 10:47
    Author     : Olof Olsson <borsna@gmail.com>
    License    : Public domain    
    Description:
        Transform DDI 1.2.2 (nesstar) Questions to SBQL
-->

<xsl:stylesheet 
    xsi:schemaLocation="sqbl:1 https://raw.github.com/LegoStormtroopr/sqbl-schema/master/Schemas/sqbl.xsd"
    xmlns:sqbl="sqbl:1"
    xmlns:ddic="http://www.icpsr.umich.edu/DDI"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="ddic"
    version="1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="prefered-lang">en</xsl:param>
    
    <!-- If you dont specify any lang in your DDI, Klingon will be default. Qaplá!-->
    <xsl:param name="default-lang">tlh</xsl:param>
    
    <xsl:template match="*">
        <xsl:apply-templates select="//ddic:codeBook"/>
    </xsl:template>
    
    <xsl:template match="ddic:codeBook">
        <sqbl:QuestionModule xsi:schemaLocation="sqbl:1 https://raw.github.com/LegoStormtroopr/sqbl-schema/master/Schemas/sqbl.xsd">
            <xsl:attribute name="name">id-<xsl:value-of select="substring(@id,0,29)"/></xsl:attribute>
            <sqbl:TextComponent>
                <sqbl:Title>
                    <xsl:attribute name="xml:lang">
                        <xsl:choose>
                            <xsl:when test="ddic:stdyDscr/ddic:citation/ddic:titlStmt/ddic:titl/ancestor-or-self::*[attribute::xml-lang][1]/@xml-lang">
                                <xsl:value-of select="ddic:stdyDscr/ddic:citation/ddic:titlStmt/ddic:titl/ancestor-or-self::*[attribute::xml-lang][1]/@xml-lang"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$default-lang"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <xsl:value-of select="ddic:stdyDscr/ddic:citation/ddic:titlStmt/ddic:titl/text()"/>
                </sqbl:Title>
                <sqbl:TargetRespondent></sqbl:TargetRespondent>
            </sqbl:TextComponent>
            <sqbl:ModuleLogic>
                <xsl:apply-templates select="//ddic:var[ddic:qstn/ddic:qstnLit]"/>
            </sqbl:ModuleLogic>
        </sqbl:QuestionModule>
    </xsl:template>
    
    <xsl:template match="ddic:var">
        <sqbl:Question> 
            <xsl:attribute name="name"><xsl:value-of select="substring(@ID,0,30)"/></xsl:attribute>
            <sqbl:TextComponent>
                <xsl:attribute name="xml:lang">
                    <xsl:choose>
                        <xsl:when test="ddic:qstn/ddic:qstnLit/ancestor-or-self::*[attribute::xml-lang][1]/@xml-lang">
                            <xsl:value-of select="ddic:qstn/ddic:qstnLit/ancestor-or-self::*[attribute::xml-lang][1]/@xml-lang"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$default-lang"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>                
                <sqbl:QuestionText><xsl:value-of select="ddic:qstn/ddic:qstnLit"/></sqbl:QuestionText>
            </sqbl:TextComponent>
            <sqbl:ResponseType>
                <xsl:choose>
                    <xsl:when test="ddic:catgry">
                        <sqbl:CodeList>
                            <sqbl:Codes>
                                <xsl:apply-templates select="ddic:catgry"/>
                            </sqbl:Codes>
                        </sqbl:CodeList>
                    </xsl:when>
                    <xsl:when test="ddic:varFormat[@type ='numeric']">
                        <sqbl:Number/>
                    </xsl:when>
                    <xsl:otherwise>
                        <sqbl:Text/>
                    </xsl:otherwise>
                </xsl:choose>
            </sqbl:ResponseType>
        </sqbl:Question>
    </xsl:template>
    
    <xsl:template match="ddic:catgry">
        <sqbl:CodePair>
            <xsl:attribute name="code"><xsl:value-of select="ddic:catValu"/></xsl:attribute>
            <sqbl:TextComponent>
                <xsl:attribute name="xml:lang">
                    <xsl:choose>
                        <xsl:when test="ancestor-or-self::*[attribute::xml-lang][1]/@xml-lang">
                            <xsl:value-of select="ancestor-or-self::*[attribute::xml-lang][1]/@xml-lang"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$default-lang"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>   
                <xsl:value-of select="ddic:labl"/>
            </sqbl:TextComponent>
        </sqbl:CodePair>
    </xsl:template>
    
</xsl:stylesheet>