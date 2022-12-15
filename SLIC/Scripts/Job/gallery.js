$(document).ready(function () {
    var image_count = 0;

    try {
        $('#imageTypes a').unbind('click');

        $("#imageTypes a").click(function () {

            var id = $(this).attr('id');
            var currentFieldElement = this;
            var node = $(currentFieldElement).parents('#leftImagePanel').next('#rightImagePanel').find('#gallery');
            $(node).html('');
            $(node).prev('#ajaxLoader').show();

            $.post("/Job/GetImageIds", { "visitId": $("#currentVisitId").val(), "imageType": id },
    function (data) {
        // var array = data.split(',');
        image_count = data.length;

        if (data.length > 0) {
            //images found
            var selector = $(currentFieldElement).parents('#leftImagePanel').next('#rightImagePanel').find('#gallery');

            $(selector).append('<ul id="myGallery"></ul>');
            $('.gv_navZoomOut').show();
            for (var id in data) {
                $.post("/Job/GetImage", { "imageId": data[id] },
    function (data) {

        if ($(currentFieldElement).attr('id') == 1) /*Claim Form Image */{
            // For Claim Form Image don't use Gallery View
            $(selector).prev('#ajaxLoader').hide();
            $(selector).find('#myGallery').css('display', 'block');
            $(selector).find('#myGallery').css('list-style', 'none');
            $(selector).find('#myGallery').append('<li><img title="aaa" alt="image" src="../../HandlerClasses/imagehandler.ashx?path=' + data + '" />');
        } else {
            // For Other Image Categories use Gallery View
            CreateImageGallery(data, image_count, selector);
        }

    }); //end GetImage post request  

            } //End for loop 
        } else {
            //no images found
            $(node).prev('#ajaxLoader').hide();
            $(node).html('<div> No images available for this category. </div>');
            $('.gv_navZoomOut').hide();
        }
    }); //end GetImageIds post request
        }); //end <a> click event
    } catch (e) {
        //  alert(e);
    }
});                  //end document ready


function CreateImageGallery(data,total_images,selector_div)
{
  var gallery =$(selector_div).find('#myGallery');

  $(gallery).append('<li><img title="aaa" src="../../HandlerClasses/imagehandler.ashx?path=' + data + '" />');

        if ($(gallery).find('li').length == total_images) {       
        //Once all the images have been loaded use gallery view
            $(selector_div).prev('#ajaxLoader').hide();          
           $(gallery).galleryView({
                panel_width: 800,
                panel_height: 380,
                frame_width: 90,
                frame_height: 60
            });
        }

    }

