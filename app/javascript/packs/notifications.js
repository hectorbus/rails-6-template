var toastr = require("toastr");
let time = 5000;
toastr.options = {
    closeButton: true,
    debug: false,
    newestOnTop: true,
    progressBar: false,
    positionClass: 'toast-top-right',
    preventDuplicates: false,
    onclick: null,
    showDuration: 300,
    hideDuration: 500,
    timeOut: time,
    extendedTimeOut: '1000',
    showEasing: 'swing',
    hideEasing: 'linear',
    showMethod: 'fadeIn',
    hideMethod: 'fadeOut'
};

let notifications = document.getElementById('notifications');
if (notifications !== null) {
    let notificationsData = JSON.parse(notifications.dataset.notifications);
    notificationsData.map((notification, index) => {
        toastr.options = {
          ...toastr.options,
          timeOut: time,
        };
        time += 500;
        if (notification[0] === 'alert') {
            toastr.warning(notification[1]);
        } else if (notification[0] === 'notice') {
            toastr.info(notification[1]);
        }
    });
}

export { toastr };
