var master = $('#master');
var header = $(master).find('.header');
var content = $(master).find('.content');
var demo = $(content).find('.demo');
var docs = $(content).find('.docs');

function showSection(sectionName)
{
   if( $(content).find('.'+sectionName+':visible').length ) return;
   
   //Setup demos
   if(sectionName == 'demo') setupDemo();
   
   //Show content
   var speed = 'fast';
   $(content).children('div').fadeOut(speed);
   $(content).find('.'+sectionName).fadeIn(speed);
}

function setupDemo()
{
   if(demo === null) return;
   
   //Setup examples
   $(demo).find('.example').each(function(){
      //Create view source link
      var link = $(document.createElement('span')).addClass('source')
                     .text('View code')
                     .prependTo(this)
                     .simpletip({
                        persistent: true, 
                        focus: true, 
                        position: 'right', 
                        offset: [20, 0],
                        content: '<h3>JavaScript code</h3>'
                     });
      
      //Find the code content and append to the tooltip
      var api = link.simpletip();
      var tooltip = $(api.getTooltip());
      var content = $(this).find('code:first').appendTo(tooltip).show();
   })
   
   //Simple demos
   $(demo).find('.simple-hover a').simpletip({ fixed: false });
   $(demo).find('.simple-hover-fixed a').simpletip();
   $(demo).find('.simple-click a').simpletip({ persistent: true, content: 'Click me to close!' });
   $(demo).find('.simple-content a').simpletip({ persistent: true, content: '<img class="pngfix" src="/simpletip/images/logo_small.png" />' });
   
   //Positioning demos
   $(demo).find('.position-left a').simpletip({ fixed: true, position: 'left' });
   $(demo).find('.position-right a').simpletip({ fixed: true, position: 'right' });
   $(demo).find('.position-top a').simpletip({ fixed: true, position: 'top' });
   $(demo).find('.position-bottom a').simpletip({ fixed: true, position: 'bottom' });
   $(demo).find('.position-absolute a').simpletip({ fixed: true, position: [100, 730], content: 'Absolute position' });
   $(demo).find('.position-relative a').simpletip({ fixed: true, position: ["0", "-100"], content: 'Relative position' });
   $(demo).find('.position-mixed a').simpletip({ fixed: true, position: ["40", 740], content: 'Mixed type position' });
   $(demo).find('.position-offset a').simpletip({ position: 'right', offset: [30, 0], content: 'Offset position' });
   
   //Effects demos
   $(demo).find('.effects-slide a').simpletip({ position: 'top', showEffect: 'slide', hideEffect: 'slide' });
   $(demo).find('.effects-fade a').simpletip({ position: 'top' });
   $(demo).find('.effects-seperate a').simpletip({ position: 'top', showEffect: 'slide', hideEffect: 'fade' });
   $(demo).find('.effects-custom-show a').simpletip({
      position: 'bottom',
      showEffect: 'custom',
      showCustom: function(){
         $(this).css({ 
            fontSize: '12px', display: 'block' 
         })
         .animate({ 
            fontSize: '20px' 
         }, 400);
      }
   });
   $(demo).find('.effects-custom-both a').simpletip({
      position: 'bottom',
      showEffect: 'custom',
      hideEffect: 'custom',
      showCustom: function(){
         $(this).animate({ width: '150px', opacity: 1, display: 'block' }, 400)
      },
      hideCustom: function(){
         $(this).animate({ width: '100px', opacity: 0, display: 'none' }, 400)
      }
   });
   $(demo).find('.effects-custom-time a').simpletip({
      position: 'right',
      showEffect: 'custom',
      showCustom: function(showTime){
         $(this).css({
            borderWidth: 'inherit', fontSize: '12px', display: 'block'
         })
         .animate({ 
            borderWidth: '4px', fontSize: '16px' 
         }, showTime)
      }
   });
   
   //Dynamic demos
   var arrayData = ['Content for tooltip 1', 'Content for tooltip 2', 'Content for tooltip 3'];
   $(demo).find('.dynamic-array a').each(function(i){
      $(this).simpletip({ content: arrayData[i] });
   });
   $(demo).find('.dynamic-ajax a').simpletip().simpletip().load('/projects/simpletip/content.txt');
   $(demo).find('.dynamic-ajax-onshow a').simpletip({ content: 'This content was loaded using the onBeforeShow callback!'});
   $(demo).find('.dynamic-update a').simpletip({ 
      onBeforeShow: function(){ 
         var curDate = new Date();
         this.update(curDate.getSeconds() + ' seconds have elapsed in this minute.'); 
      } 
   });
   
   demo = null;
}

$(document).ready(function(){
   //Hide pages initally
   $('.content > div').hide();
   
   //Setup page
   var elem = $(content).find('.'+section);
   if(section.length && elem.length)
   {
      elem.show();
      if(section == 'demo') setupDemo();
   }
   

   var tips = {
      demo: 'Check out some live examples!',
      docs: 'Learn about the library and its many options!',
      downloads: 'Compatible with <i>jQuery 1.2.x</i> upwards!'
   } 
   
   //Setup header tooltips
   $(header).find('a').each(function()
   {
      var offset = 10;
      var position = 'bottom';
      var content = tips[ $(this).attr('rel') ];
      
      if($(this).hasClass('downloads'))
      {
         if(!$(this).hasClass('beta'))
         {
            position = 'top';
            offset = -10;
         }
         else content = 'Checkout Simpletips successor library, qTip.';
      }
      
      $(this).simpletip({
         position: position,
         offset: [0, offset],
         boundryCheck: false,
         content: content
      });
   });
   
   //Setup page links
   $('a[name]').remove();
   $('a[href^="#"]').attr('href', '#').addClass('page').click(function(){ showSection( $(this).attr('rel') ); })
   
   //Setup code tooltips
   $(docs).find('code.js').simpletip({ fixed: false, content: 'JavaScript code example' });
   $(docs).find('code.css').simpletip({ fixed: false, content: 'CSS code example' });
})