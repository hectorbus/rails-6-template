import swal from 'sweetalert';
import $ from 'jquery';
import I18n from 'i18n-js';
import 'javascripts/i18n/translations';
I18n.locale = window.I18n.locale;

document.addEventListener("turbolinks:before-cache", function () {
    $('[data-toggle="m-tooltip"]').tooltip('hide');
    $('.selectpicker').selectpicker('destroy');
});

$(document).on('turbolinks:load', function () {

    // Custom search field for table content
    $('.search-field').on('change', function(){
        let $this = $(this);
        $this.toggleClass('expand-input', $this.val() ? true : false);
    });

    // Sweet Alert modal for delete elements
    $('.btn-destroy').click(function(event) {
        let element, resource, resourceId, resourceMsg, row, url, authenticityToken;
        element = $(this);
        row = element.closest('tr');
        resource = element.data('resource');
        resourceId = element.data('resource-id');
        resourceMsg = element.data('resource-message');
        url = `/${resource}/${resourceId}`;
        authenticityToken = $('[name="csrf-token"]')[0] && $('[name="csrf-token"]')[0].content;
        swal(resourceMsg, {
            buttons: {
                cancel: I18n.t('messages.cancel'),
                confirm: {
                    text: I18n.t('messages.delete'),
                    closeModal: true
                }
            }
        }).then(function(isConfirm) {
            if (!isConfirm) {
                return;
            }
            $.ajax({
                url: url,
                data: { authenticity_token: authenticityToken },
                type: 'DELETE',
                dataType: 'json',
                success: function(data) {
                    swal({
                        title: I18n.t('messages.done'),
                        text: I18n.t('messages.deleted'),
                        type: 'success',
                        confirmButtonText: I18n.t('messages.ok')
                    });
                    $(row).remove();
                },
                error: function(error) {
                    console.log(error);
                    swal(I18n.t('messages.error'), I18n.t('messages.try_again'), 'error');
                }
            });
        });
    });

    // bootstrap-select initializer
    $('.selectpicker, .per-page-selectpicker').selectpicker();

    // Submit for elements per page on tables
    $('.per-page-pagination').on('change', function () {
        $(this).closest('form').submit();
    });

    // Simulate click for file_field on edit user
    $('.hover-image').on('click', function(){
      $('.update-picture').click();
    });

    // Replace profile picture on edit user
    $('.update-picture').on('change', function(){
      readURL(this);
    });

});

let readURL = (input) => {
  if (input.files[0]){
    var reader = new FileReader();
    let ext = getFileExtension(input.files[0].name);
    let validImageTypes = ['gif', 'jpeg', 'png', 'jpg'];
    if (validImageTypes.includes(ext)) {
      reader.readAsDataURL(input.files[0]);
    }
  }

  reader.onload = function(e){
    $('.profile-picture').attr('src', e.target.result);
    $('.profile-picture').attr('style', 'object-fit:cover; width:130px; height:130px;');
  }
};

let getFileExtension = (filename) => {
  return filename.split('.').pop();
};

let cascadeSelects = (source, destination, url) => {
    let ajaxRequest = (resource, edit) => {
        if (resource !== '') {
            $.get(url, {resource: resource}, function (data) {
                destination.empty();
                if (data.length > 0) {
                    for (let action of data) {
                        destination.append($('<option>', {value: action[0], text: action[1]}));
                    }
                    edit && destination.val(destination.data('value'));
                } else {
                    destination.append($('<option>', {value: '', text: I18n.t('helpers.select.no_options')}));
                }
            })
                .fail(function () {
                    toastr.warning(I18n.t('messages.try_again'));
                });
        }
    };

    ajaxRequest(source.val(), true);

    source.on('change', function (e) {
        let resource = $(e.target).val();
        ajaxRequest(resource, false);
    });
};

export { cascadeSelects };
