function getItemCount(id) {
    return $('#itemCount'+id).text();
}

function increaseItemCount(elem) {
    var id = elem.id;
    var decreaseCount = document.getElementsByClassName('decrease-item-count'+id)[0];
    var count = getItemCount(id);
    $('#itemCount'+id).html(parseInt(count) + 1);
    if (document.getElementsByClassName('decrease-item-count'+id)[0].hasAttribute('disabled')) {
        document.getElementsByClassName('decrease-item-count'+id)[0].removeAttribute('disabled');
        document.getElementsByClassName('add-to-cart'+id)[0].removeAttribute('disabled');
    }
}

function decreaseItemCount(elem) {
    var id = elem.id;
    var decreaseCount = document.getElementsByClassName('decrease-item-count'+id)[0];
    var count = getItemCount(id);
    $('#itemCount'+id).html(parseInt(count) - 1);
    if (count - 1 == 0) {
        document.getElementsByClassName('decrease-item-count'+id)[0].setAttribute('disabled', 'true');
        document.getElementsByClassName('add-to-cart'+id)[0].setAttribute('disabled', 'true');
    }
}