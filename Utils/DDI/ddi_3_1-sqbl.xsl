<?xml version="1.0" encoding="UTF-8"?>
<!--
    Document   : ddi-sbql.xsl
    Created on : den 2 juni 2013, 14:32
    Author     : Olof Olsson <borsna@gmail.com>
    License    : Public domain    
    Description:
        Transform DDI 3.1 Questionaires to SBQL
    
    TODO:
        *done* handle MultipleQuestionItem as Statements
        fix the order of the questions
    
-->

<xsl:stylesheet 
    xsi:schemaLocation="sqbl:1 https://raw.github.com/LegoStormtroopr/sqbl-schema/master/Schemas/sqbl.xsd"
    xmlns:sqbl="sqbl:1"
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
    
    <xsl:param name="prefered-lang">en</xsl:param>
    
    <!-- If you dont specify any lang in your DDI, Klingon will be default. Qaplá!-->
    <xsl:param name="default-lang">tlh</xsl:param>
        
   <xsl:template match="*">
        <xsl:apply-templates select="//s:StudyUnit"/>
    </xsl:template>    
        
    <xsl:template match="s:StudyUnit">
        <sqbl:QuestionModule xsi:schemaLocation="sqbl:1 https://raw.github.com/LegoStormtroopr/sqbl-schema/master/Schemas/sqbl.xsd">
            <xsl:attribute name="name">id-<xsl:value-of select="substring(@id,0,29)"/></xsl:attribute>
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
                    <xsl:when test="//d:ControlConstructScheme">
                        <xsl:apply-templates select="//d:ControlConstructScheme" />
                    </xsl:when>
                    <xsl:when test="d:DataCollection/d:QuestionScheme">
                        <xsl:apply-templates select="d:DataCollection/d:QuestionScheme" />
                    </xsl:when>
                </xsl:choose>
            </sqbl:ModuleLogic>
        </sqbl:QuestionModule>
    </xsl:template>
    
    <xsl:template match="d:ControlConstructScheme">
        <xsl:apply-templates select="d:QuestionConstruct | d:StatementItem"/>
    </xsl:template>
    
    <xsl:template match="d:QuestionConstruct">
        <xsl:variable name="qrId" select="d:QuestionReference/r:ID"/>
        <xsl:apply-templates select="//d:QuestionItem[@id = $qrId] | //d:MultipleQuestionItem[@id = $qrId]" />
    </xsl:template>
    
    <xsl:template match="d:QuestionScheme">       
        <xsl:apply-templates select="d:QuestionItem | d:MultipleQuestionItem" />                  
    </xsl:template>

    <xsl:template match="d:QuestionItem">
        <sqbl:Question>        
            <xsl:attribute name="name">q<xsl:value-of select="substring(@id,0,30)"/></xsl:attribute>
            <xsl:for-each select="d:QuestionText">
                <sqbl:TextComponent>
                    <xsl:attribute name="xml:lang">
                        <xsl:choose>
                            <xsl:when test="d:LiteralText/ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang">
                                <xsl:value-of select="d:LiteralText/ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$default-lang"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <sqbl:QuestionText><xsl:value-of select="d:LiteralText/d:Text"/></sqbl:QuestionText>
                </sqbl:TextComponent>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="d:TextDomain">
                    <sqbl:ResponseType>
                        <sqbl:Text/>
                    </sqbl:ResponseType>
                </xsl:when>
                <xsl:when test="d:CodeDomain">
                    <sqbl:ResponseType>
                        <sqbl:CodeList>
                            <xsl:variable name="qsId" select="d:CodeDomain/r:CodeSchemeReference/r:ID"/>
                            <xsl:apply-templates select="//l:CodeScheme[@id = $qsId]" />
                        </sqbl:CodeList>
                    </sqbl:ResponseType>
                </xsl:when>
                <xsl:when test="d:NumericDomain">
                    <sqbl:ResponseType>
                        <sqbl:Number/>
                    </sqbl:ResponseType>
                </xsl:when>
            </xsl:choose>
        </sqbl:Question>
    </xsl:template>
    
    <xsl:template match="d:MultipleQuestionItem">
        <sqbl:Statement>
            <xsl:attribute name="name"><xsl:value-of select="substring(@id,0,32)"/></xsl:attribute>
            <xsl:for-each select="d:QuestionText">
               <sqbl:TextComponent>
                   <xsl:attribute name="xml:lang">
                       <xsl:choose>
                           <xsl:when test="./ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang">
                               <xsl:value-of select="d:LiteralText/ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang"/>
                           </xsl:when>
                           <xsl:otherwise>
                               <xsl:value-of select="$default-lang"/>
                           </xsl:otherwise>
                       </xsl:choose>
                   </xsl:attribute>   
                   <sqbl:StatementText><xsl:value-of select="d:LiteralText/d:Text"/></sqbl:StatementText>
               </sqbl:TextComponent> 
            </xsl:for-each>
        </sqbl:Statement>
        <xsl:apply-templates select="d:SubQuestions/d:QuestionItem"/>
    </xsl:template>
    
    <xsl:template match="d:StatementItem">
        <sqbl:Statement>
            <xsl:attribute name="name"><xsl:value-of select="substring(@id,0,32)"/></xsl:attribute>
            <xsl:for-each select="d:DisplayText">
                <sqbl:TextComponent>
                    <xsl:attribute name="xml:lang">
                        <xsl:choose>
                            <xsl:when test="./ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang">
                                <xsl:value-of select="d:LiteralText/ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$default-lang"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>                    
                    <sqbl:StatementText><xsl:value-of select="d:LiteralText/d:Text"/></sqbl:StatementText>
                </sqbl:TextComponent>
            </xsl:for-each>
        </sqbl:Statement>
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
        <xsl:for-each select="r:Label">
            <sqbl:TextComponent>
                <xsl:attribute name="xml:lang"><xsl:value-of select="ancestor-or-self::*[attribute::xml:lang][1]/@xml:lang"/></xsl:attribute>
                <xsl:value-of select="."/>
            </sqbl:TextComponent>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>