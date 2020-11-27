/* run this in your Engage Publish instance */
/* copy/paste output to excel, convert to CSV *
/* be sure to change to UTF-8 encoding, not BOM */
/* run import, clean up images: '' and categories: along with redirect from format */

select 
Name,
lower(replace(replace(replace(replace(replace(replace(REPLACE(REPLACE(Name,' ','-'),',',''),'+',''),'.',''),'!',''),'?',''),'&rsquo;',''),'*','')), --url
ArticleText,--body
startdate,--publishdate
'html',--format
'', --image
'', --categories
CASE  
     WHEN 
		displaytabid=53 
		THEN cast('/Blog/itemId/' + cast(pa.itemid as nvarchar(max)) + '/' + substring(replace(replace(replace(replace(replace(replace(REPLACE(REPLACE(Name,' ','-'),',',''),'+',''),'.',''),'!',''),'?',''),'&rsquo;',''),'*',''),0,49) as nvarchar(max))
	 ELSE 
		cast('/Video/itemId/' + cast(pa.itemid as nvarchar(max)) + '/' + substring(replace(replace(replace(replace(replace(replace(REPLACE(REPLACE(Name,' ','-'),',',''),'+',''),'.',''),'!',''),'?',''),'&rsquo;',''),'*',''),0,49) as nvarchar(max))
END  
,--redirect_from
pa.itemid,
* 

from Publish_vwArticles pa 

where 
IsCurrentVersion=1
and portalid=0
order by pa.itemid
