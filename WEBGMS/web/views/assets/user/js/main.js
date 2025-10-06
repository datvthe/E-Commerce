(function ($) {
    "use strict";

    // Spinner
    var spinner = function () {
        setTimeout(function () {
            if ($('#spinner').length > 0) {
                $('#spinner').removeClass('show');
            }
        }, 1);
    };
    spinner(0);
    
    
    // Initiate the wowjs
    new WOW().init();


    // Sticky Navbar
    $(window).scroll(function () {
        if ($(this).scrollTop() > 45) {
            $('.nav-bar').addClass('sticky-top shadow-sm');
        } else {
            $('.nav-bar').removeClass('sticky-top shadow-sm');
        }
    });


    // Hero Header carousel
    $(".header-carousel").owlCarousel({
        items: 1,
        autoplay: true,
        smartSpeed: 2000,
        center: false,
        dots: false,
        loop: true,
        margin: 0,
        nav : true,
        navText : [
            '<i class="bi bi-arrow-left"></i>',
            '<i class="bi bi-arrow-right"></i>'
        ]
    });


    // ProductList carousel
    $(".productList-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 2000,
        dots: false,
        loop: true,
        margin: 25,
        nav : true,
        navText : [
            '<i class="fas fa-chevron-left"></i>',
            '<i class="fas fa-chevron-right"></i>'
        ],
        responsiveClass: true,
        responsive: {
            0:{
                items:1
            },
            576:{
                items:1
            },
            768:{
                items:2
            },
            992:{
                items:2
            },
            1200:{
                items:3
            }
        }
    });

    // ProductList categories carousel
    $(".productImg-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1500,
        dots: false,
        loop: true,
        items: 1,
        margin: 25,
        nav : true,
        navText : [
            '<i class="bi bi-arrow-left"></i>',
            '<i class="bi bi-arrow-right"></i>'
        ]
    });


    // Single Products carousel
    $(".single-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1500,
        dots: true,
        dotsData: true,
        loop: true,
        items: 1,
        nav : true,
        navText : [
            '<i class="bi bi-arrow-left"></i>',
            '<i class="bi bi-arrow-right"></i>'
        ]
    });


    // ProductList carousel
    $(".related-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1500,
        dots: false,
        loop: true,
        margin: 25,
        nav : true,
        navText : [
            '<i class="fas fa-chevron-left"></i>',
            '<i class="fas fa-chevron-right"></i>'
        ],
        responsiveClass: true,
        responsive: {
            0:{
                items:1
            },
            576:{
                items:1
            },
            768:{
                items:2
            },
            992:{
                items:3
            },
            1200:{
                items:4
            }
        }
    });



    // Product Quantity
    $('.quantity button').on('click', function () {
        var button = $(this);
        var oldValue = button.parent().parent().find('input').val();
        if (button.hasClass('btn-plus')) {
            var newVal = parseFloat(oldValue) + 1;
        } else {
            if (oldValue > 0) {
                var newVal = parseFloat(oldValue) - 1;
            } else {
                newVal = 0;
            }
        }
        button.parent().parent().find('input').val(newVal);
    });


    
   // Back to top button
   $(window).scroll(function () {
    if ($(this).scrollTop() > 300) {
        $('.back-to-top').fadeIn('slow');
    } else {
        $('.back-to-top').fadeOut('slow');
    }
    });
    $('.back-to-top').click(function () {
        $('html, body').animate({scrollTop: 0}, 1500, 'easeInOutExpo');
        return false;
    });


   // Search Autocomplete (local history + hints)
   $(document).ready(function(){
       var $input = $("input[placeholder='Search Looking For?']");
       if ($input.length === 0) return;
       var $dropdown = $(
           '<div id="dropdownToggle123" class="dropdown-menu show" style="position:absolute; top:100%; left:0; right:0; display:none;"></div>'
       );
       $input.parent().append($dropdown);

       function getHistory(){
           try { return JSON.parse(localStorage.getItem('searchHistory')||'[]'); } catch(e){ return []; }
       }
       function saveHistory(term){
           if (!term) return;
           var list = getHistory();
           list = [term].concat(list.filter(function(t){ return t.toLowerCase() !== term.toLowerCase(); })).slice(0,8);
           localStorage.setItem('searchHistory', JSON.stringify(list));
       }
       function getHints(prefix){
           var staticHints = ['iPhone', 'Samsung', 'Laptop', 'Tai nghe', 'Bàn phím', 'Chuột', 'Màn hình'];
           var hist = getHistory();
           var pool = hist.concat(staticHints);
           prefix = (prefix||'').toLowerCase();
           return pool.filter(function(x){ return x.toLowerCase().indexOf(prefix) !== -1; }).slice(0,8);
       }
       function render(list){
           if (!list.length) { $dropdown.hide(); return; }
           $dropdown.empty();
           list.forEach(function(item){
               var $it = $('<a class="dropdown-item" href="#"></a>').text(item);
               $it.on('mousedown', function(e){ e.preventDefault(); $input.val(item); $dropdown.hide(); });
               $dropdown.append($it);
           });
           $dropdown.show();
       }

       $input.on('input focus', function(){
           var q = $(this).val();
           render(getHints(q));
       });
       $(document).on('click', function(e){
           if (!$.contains($input.parent()[0], e.target)) $dropdown.hide();
       });
       $input.closest('.d-flex').find('button.btn.btn-primary').on('click', function(){
           var term = $input.val();
           saveHistory(term);
       });
   });

})(jQuery);

