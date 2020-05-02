import $ from 'jquery';
import { cascadeSelects } from 'packs/general';

$(document).on('turbolinks:load', function () {
    let $permissionController = $('#permission_controller');
    if ($permissionController.length > 0) {
        let $permissionAction = $('#permission_action');
        let url = $permissionController.data('url');
        cascadeSelects($permissionController, $permissionAction, url);
    }

    $('#createSeeds').click(() =>{
        $.ajax({
            url: "permissions/generate_seeds",
            method: "GET",
            dataType: "json"
        }).done((data) => {
            toastr.success(I18n.t('messages.seeds_success'));
        }).fail(() => {
            toastr.error(I18n.t('messages.seeds_error'));
        }).always(() => {
        });
    });
});
