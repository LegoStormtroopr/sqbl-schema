<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : ddi-sbql.xsl
    Created on : den 2 juni 2013, 14:32
    Author     : Olof Olsson <borsna@gmail.com>
    License    : Public domain    
    Description:
        Transform DDI 3.1 Questionaires to SBQL
    
-->

<xsl:stylesheet 
    xsi:schemaLocation="sqbl:1 https://raw.github.com/LegoStormtroopr/sqbl-schema/master/Schemas/sqbl.xsd"
    xmlns:sqbl="sqbl:1 https://raw.github.com/LegoStormtroopr/sqbl-schema/master/Schemas/sqbl.xsd"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:g="ddi:group:3_1"
    xmlns:d="ddi:datacollection:3_1"
    xmlns:dce="ddi:dcelements:3_1"
    xmlns:c="ddi:conceptualcomponent:3_1"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_1"
    xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
    xmlns:ddi="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd"
    xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
    xmlns:l="ddi:logicalproduct:3_1"
    xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
    xmlns:pd="ddi:physicaldataproduct:3_1"
    xmlns:cm="ddi:comparative:3_1"
    xmlns:s="ddi:studyunit:3_1"
    xmlns:r="ddi:reusable:3_1"
    xmlns:pi="ddi:physicalinstance:3_1"
    xmlns:ds="ddi:dataset:3_1"
    xmlns:pr="ddi:profile:3_1"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="g d dce c xhtml a m1 ddi m2 l m3 pd cm s r pi ds pr xsl"
    version="1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="prefered-lang"></xsl:param>
        
   <xsl:template match="*">
        <xsl:apply-templates select="s:StudyUnit"/>
    </xsl:template>    
        
    <xsl:template match="s:StudyUnit">
        <sqbl:QuestionModule xmlns="sqbl:1">
            <sqbl:TextComponent>
                <sqbl:Title>
                    <xsl:choose>
                        <xsl:when test="r:Citation/r:Title[@xml:lang=$prefered-lang]">
                            <xsl:value-of select="r:Citation/r:Title[@xml:lang=$prefered-lang]/text()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="r:Citation/r:Title[1]/text()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </sqbl:Title>
                <sqbl:TargetRespondent></sqbl:TargetRespondent>
            </sqbl:TextComponent>
            <sqbl:ModuleLogic>
                <xsl:choose>
                    <xsl:when test="d:DataCollection/d:ControlConstructScheme">
                        <xsl:apply-templates select="d:DataCollection/d:ControlConstructScheme" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="d:DataCollection/d:QuestionScheme" />
                    </xsl:otherwise>
                </xsl:choose>
            </sqbl:ModuleLogic>
        </sqbl:QuestionModule>
    </xsl:template>
    
    <xsl:template match="d:ControlConstructScheme">
        <xsl:apply-templates select="d:QuestionConstruct"/>
    </xsl:template>
    
    <xsl:template match="d:QuestionConstruct">
        <xsl:variable name="qrId" select="d:QuestionReference/r:ID"/>
        <xsl:apply-templates select="//d:QuestionItem[@id = $qrId]" />
    </xsl:template>
    
    <xsl:template match="d:QuestionScheme">
        <xsl:apply-templates select="./d:QuestionItem" />
    </xsl:template>

    <xsl:template match="d:QuestionItem">
        <sqbl:Question>
            <xsl:attribute name="name">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <sqbl:TextComponent>
                <sqbl:QuestionText><xsl:value-of select="d:QuestionText/d:LiteralText/d:Text"/></sqbl:QuestionText>
            </sqbl:TextComponent>
            <xsl:choose>
                <xsl:when test="d:TextDomain"><sqbl:Text></sqbl:Text></xsl:when>
                <xsl:when test="d:CodeDomain">
                    <sqbl:CodeList>
                        <xsl:variable name="qsId" select="d:CodeDomain/r:CodeSchemeReference/r:ID"/>
                        <xsl:apply-templates select="//l:CodeScheme[@id = $qsId]" />
                    </sqbl:CodeList>
                </xsl:when>
            </xsl:choose>
        </sqbl:Question>
    </xsl:template>
    
    <xsl:template match="l:CodeScheme">
        <sqbl:Codes>
            <xsl:apply-templates select="l:Code"/>
        </sqbl:Codes>
    </xsl:template>
    
    <xsl:template match="l:Code">
        <sqbl:CodePair>
           <xsl:attribute name="code"><xsl:value-of select="l:Value"/></xsl:attribute>
           <xsl:variable name="cId" select="l:CategoryReference/r:ID"/>
           <xsl:apply-templates select="//l:Category[@id = $cId]" />
        </sqbl:CodePair>
    </xsl:template>
    
    <xsl:template match="l:Category">
        <sqbl:TextComponent>
            <xsl:value-of select="r:Label"/>
        </sqbl:TextComponent>
    </xsl:template>
</xsl:stylesheet>