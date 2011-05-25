jq(function() {
    jq(".collapsible-header").click(function () {
        if(jQuery(this).hasClass("expanded")) {
            jq("#collapsible-banner").hide("blind", { direction: "vertical" }, 2000);
            jq(this).removeClass("expanded").addClass("collapsed");      
        } else {
            jq("#collapsible-banner").show("blind", { direction: "vertical" }, 2000);
            jq(this).removeClass("collapsed").addClass("expanded");  
        }
        return false;
    });
    jq("#share").hover(function() {
        wb.saveState();
        return false;
    })
    jq("#embed_map").click(function() {
        wb.updateEmbedLink();
        jq("#share_window").fadeIn()        
        return false;
    });
    jq("#close_embed").click(function() {
        jq("#share_window").fadeOut()
        return false;
    });
    
    jq("#locations_list .inactive").click(function () {
        return false;
    });

    jq.each(wb.sectors, function(sector_name, sector_attrs) {
        jq('#sectorcontrol_' + sector_name).tipsy({gravity:  jq.fn.tipsy.autoNS});
        jq('#sectorcontrol_' + sector_name).click(function(){
            return wb.toggleSector(sector_name);
        })
    });
    jq('#mines_sectors li').click(function() {
        wb.toggleMines("Mines", jq(this).attr("original-title"))
    })
    jq('#sall').click(function(){
        wb.toggleSector('all');
        return false;
    });
    jq('.subtotal').live('click',function() {
        wb.sectorPieChart("all");
        return false;
    });
    jq('table#projects-table_grid tr').hover(function() { jq(this).addClass('active')},function() { jq(this).removeClass('active')})
    jq('.simpleshare_link').click(function() { jq('#share-pane').toggle() });
    jq('#share-pane .close').click(function() { jq('#share-pane').toggle() });
});