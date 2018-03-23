define(['jquery', 'layer'], function($, layer){
    var goTop = function(){
        var $btn = $('#back-to-top-btn');
        var $window = $(window);
        var trigger = 100;
        var checkBtn = function(){
            if ($window.scrollTop() > trigger) {
                $btn.show(1000);
            } else {
                $btn.hide();
            }
        };
        checkBtn();
        if ($btn.length > 0) {
            $window.on('scroll', function(){
                checkBtn();
            });
            $btn.on('click', function(){
               $('html,body').animate({
                   scrollTop:0
               }, 700);
               return false;
            });
        }
    };
    var showSidebar = function(){
        var $sidebar = $('#sidebar');
        var $showBtn = $('.sidebar-toggle');
        var $firstSpan = $showBtn.find('.sidebar-toggle-line-wrap span:first');
        var $secondSpan = $showBtn.find('.sidebar-toggle-line-wrap span:eq(1)');
        var $lastSpan = $showBtn.find('.sidebar-toggle-line-wrap span:last');
        $showBtn.on('mouseover', function(){
            if (!$(this).hasClass('show-sidebar')) {
                $firstSpan.css({top:'2px', transform:'rotateZ(-45deg)', width:'50%', left:0});
                $secondSpan.css({top:0, transform:'rotateZ(0deg)', width:'90%', left:0});
                $lastSpan.css({top:'-2px', transform:'rotateZ(45deg)', width:'50%', left:0});
            }

        });
        $showBtn.on('mouseout', function(){
            if (!$(this).hasClass('show-sidebar')) {
                $firstSpan.css({top: 0, transform: 'rotateZ(0deg)', width: '100%', left: 0});
                $secondSpan.css({top: 0, transform: 'rotateZ(0deg)', width: '100%', left: 0});
                $lastSpan.css({top: 0, transform: 'rotateZ(0deg)', width: '100%', left: 0});
            }
        });
        $showBtn.on('click', function(){
            var width = parseInt($sidebar.css('width').replace('px', ''));
            if (width > 0) {
                $sidebar.css({width:'0px'});
                $firstSpan.css({top: 0, transform: 'rotateZ(0deg)', width: '100%', left: 0});
                $secondSpan.css({top: 0, transform: 'rotateZ(0deg)', width: '100%', left: 0, opacity:1});
                $lastSpan.css({top: 0, transform: 'rotateZ(0deg)', width: '100%', left: 0});
                $(this).removeClass('show-sidebar');
            } else {
                $sidebar.css({width:'320px'}).show();
                $firstSpan.css({top:'5px', transform:'rotateZ(-45deg)', width:'100%', left:0});
                $secondSpan.css({top:0, transform:'rotateZ(0deg)', width:'90%', left:0, opacity:0});
                $lastSpan.css({top:'-5px', transform:'rotateZ(45deg)', width:'100%', left:0});
                $(this).addClass('show-sidebar');
            }

        });
    };
    return {
        $:$,
        layer:layer,
        goTop:goTop,
        showSidebar:showSidebar
    }
});