function disableButtonsAndOverrideText(newButtonText) {
    var $j = jQuery.noConflict();
    var $buttons = $j('.btn');
    $buttons.toggleClass('btnDisabled', true).attr('disabled', 'disabled');
    $buttons.prop('value', newButtonText);
}