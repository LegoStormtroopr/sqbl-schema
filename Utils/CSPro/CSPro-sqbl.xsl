<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:exslt="http://exslt.org/common" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sqbl="sqbl:1" >
    <xsl:output method="text"/>
    <xsl:param name="agency">com.kidstrythisathome.ddirepo.legostormtroopr</xsl:param>
    <xsl:param name="base_url">www.kidstrythisathome.com</xsl:param>
    <xsl:variable name="moduleName" select="/sqbl:QuestionModule/@name" />

    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:variable name="nl">
        <xsl:text>&#10;</xsl:text>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:text>[Dictionary]&#10;</xsl:text>
        <xsl:text>Version=CSPro 5.0&#10;</xsl:text>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Label</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="$moduleName"/></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Name</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="translate($moduleName, $lowercase, $uppercase)"/></xsl:with-param>
        </xsl:call-template>
        <xsl:text>RecordTypeStart=1&#10;</xsl:text>
        <xsl:text>RecordTypeLen=1&#10;</xsl:text>
        <xsl:text>Positions=Relative&#10;</xsl:text>
        <xsl:text>ZeroFill=No&#10;</xsl:text>
        <xsl:text>DecimalChar=Yes&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>[Level]&#10;</xsl:text>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Label</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="$moduleName"/> Module</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Name</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="translate($moduleName, $lowercase, $uppercase)"/>_MOD</xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>[IdItems]&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>[Item]&#10;</xsl:text>
        <xsl:text>Label=respondent_id&#10;</xsl:text>
        <xsl:text>Name=RESP_ID&#10;</xsl:text>
        <xsl:text>Start=2&#10;</xsl:text>
        <xsl:text>Len=1&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>        
        <xsl:text>[Record]&#10;</xsl:text>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Label</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="$moduleName"/> Module</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Name</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="translate($moduleName, $lowercase, $uppercase)"/>_MOD</xsl:with-param>
        </xsl:call-template>
        <xsl:text>RecordTypeValue=2&#10;</xsl:text>
        <xsl:text>RecordLen=5&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>        
        <xsl:apply-templates select="//sqbl:Question"/>
    </xsl:template>
    <xsl:template match="sqbl:Question">
        <xsl:text>[Item]&#10;</xsl:text>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Label</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="./sqbl:TextComponent/sqbl:QuestionText" /></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Name</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="translate(@name, $lowercase, $uppercase)"/></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="keyValPair">
            <xsl:with-param name="key">Start</xsl:with-param>
            <xsl:with-param name="val"><xsl:value-of select="position()"/></xsl:with-param>
        </xsl:call-template>
        <xsl:text>Len=1&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        
            
    </xsl:template>
    <xsl:template match="*" />
    <xsl:template name="keyValPair">
        <xsl:param name="key"/>
        <xsl:param name="val"/>
        <xsl:value-of select="$key"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="normalize-space($val)"/>
        <xsl:text>&#10;</xsl:text>        
    </xsl:template>
</xsl:stylesheet>