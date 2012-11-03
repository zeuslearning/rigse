var expandedShareButtonid;
function showShareoptions(id,type){
    if (animating)
    {
        return false;
    }
    if(id!=expandedShareButtonid)
    {
        $$(".sharing").each(function(shareContainer){shareContainer.hide();shareContainer.removeClassName('visible');});
        $$(".share_Button").each(function(sharebtn){sharebtn.update("Share &#9660");});
    }
    var shareContainer=$("share_"+type+id);
    var afterFinishCallback = function(){
        animating = false;
        $('shareExpandCollapse_'+id).update(expandCollapseText);
    };
    
    if (shareContainer.hasClassName('visible'))
    {
        Effect.BlindUp(shareContainer, { duration: 0.2, afterFinish: afterFinishCallback });
        shareContainer.removeClassName('visible');
        expandCollapseText = "Share &#9660;";
        animating = true;
    }
    else
    {
        Effect.BlindDown(shareContainer, { duration: 0.2, afterFinish: afterFinishCallback });
        shareContainer.addClassName('visible');
        expandCollapseText = "Share &#9650;";
        expandedShareButtonid=id;
        animating = true;
    }
    return true;
}

