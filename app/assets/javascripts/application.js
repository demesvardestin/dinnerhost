//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require Chart.bundle
//= require chartkick
//= require_tree .


window.onload = e => {
    $.get('/uninitialize_firebase');
    $.get('/initialize_cart');
    var url = window.location.href;
    authState();
    $.get('/read_data_from_firestore');
};

$(function () {
    $(document).scroll(function () {
      var $nav = $(".fixed-top");
      $nav.toggleClass('scrolled', $(this).scrollTop() > $nav.height());
    });
});

toastr.options = {
    "debug": false,
    "newestOnTop": true,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "showDuration": "1000",
    "hideDuration": "1000",
    "timeOut": "1000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
};


// FIRESTORE

/// Write data to firestore
function addDataToFirestore(data) {
    $.get('/uninitialize_firebase')
    .done(resp => {
        $.get('/add_data_to_firestore', { data: data })
        .done(resp => {
            if (data["type"] === "new-item") {
                // Adding an item
                $('#availableSizes').empty();
                var inputs = document.getElementsByClassName('form-control');
                for (i = 0; i < inputs.length; i++) {
                    document.getElementById(inputs[i].id).value = '';
                }
                const addItemBtn = document.querySelector('#addItem');
                addItemBtn.removeAttribute('disabled');
                $('#addItem').html('Add item to inventory <i class="fa fa-angle-right"></i>');
            } else if (data["type"] === "order-update") {
            
                // Updating an order
                $('#status-' + data["doc_id"]).html(data["status"]);
                $('#toggle-status_' + data["doc_id"]).css('opacity', '1')
                .html('Mark as ready');
            }
        });
    });
}

function removeDataFromFirestore(data) {
    $.get('/uninitialize_firebase')
    .done(resp => {
        $.get('/remove_data_from_firestore', { data: data })
        .done(resp => {
            // console.log('Item removed!');
        });
    });
}

/// Read data from firestore
function readShopperDataFromFirestore(data, elem=null) {
    // Load shopper account details
    $('#accountDetailsLines').html(`
        <div class="text-center col-md-12" id="loadingAccountDetails">
            <span>
                <i class="fa fa-spinner fa-pulse fa-3x fa-fw theme-color"
                    style="font-size: 50px;">
                </i>
            </span><br />
            <p>Loading account details</p>
        </div>
    `);
    
    $('#' + elem).html(`
        <div class="text-center col-md-12" id="loadingAccountDetails">
            <span>
                <i class="fa fa-spinner fa-pulse fa-3x fa-fw theme-color"
                    style="font-size: 50px;">
                </i>
            </span><br />
            <p>Loading details</p>
        </div>
    `);
    
    $.get('/read_shopper_data_from_firestore', { data: data })
    .done(resp => {
        // if (elem === "storeItems") {
        //     $.get('/read_shopper_data_from_firestore', { data: {"type": "shopper-categories"} })
        // }
    });
}

function addShopperDataToFirestore(data) {
    $.get('/add_shopper_data_to_firestore', { data: data })
    .done(resp => {
        console.log('done');
    });
}

function readDataFromFirestore(data, elem=null) {
    
    //  If on inventory page
    $('.inventory-items').html(`
        <div class="text-center" id="loadingItems">
            <span>
                <i class="fa fa-spinner fa-pulse fa-3x fa-fw theme-color"
                    style="font-size: 50px;">
                </i>
            </span><br />
            <p>Loading inventory</p>
        </div>
    `);
    
    //  If on dashboard page
    $('#orderRequests').html(`
        <div class="text-center col-md-12" id="loadingOrders">
            <span>
                <i class="fa fa-spinner fa-pulse fa-3x fa-fw theme-color"
                    style="font-size: 50px;">
                </i>
            </span><br />
            <p>Loading orders</p>
        </div>
    `);
    
    $.get('/uninitialize_firebase')
    .done(resp => {
        $.get('/read_data_from_firestore', { data: data })
        .done(finalResp => {
            if (data.type === 'items_ordered') {
                $.get('/read_data_from_firestore', {data: data});
            }
        });
        // console.log('Data successfully retrieved!');
    });
}


// INVENTORY

/// Delete an item
function deleteItem(id) {
    var data = {
        "type": "items",
        "id": id
    };
    removeDataFromFirestore(data);
}

/// Category selection
function setCategory(elem) {
    var id = elem.id;
    document.getElementById('itemCategory').value = id;
    var category = $('#'+id).text();
    // console.log(category);
    $('.filter-items').html(
        category + ' <i class="fa fa-angle-down"></i>'
    );
}

/// Taxability selection
function setTaxable(elem) {
    var id = elem.id;
    var taxId = id.split('-')[1]
    document.getElementById('itemTaxable').value = taxId;
    var taxed = $('#'+id).text();
    console.log(taxed);
    $('.taxable-items').html(
        taxed + ' <i class="fa fa-angle-down"></i>'
    );
}

// Add an item
function addItem(elem) {
    var name = document.getElementById('itemName').value;
    var ndc = document.getElementById('itemNDC').value;
    var strength = document.getElementById('itemStrength').value;
    var availableSizes = document.querySelector('#availableSizes');
    if (availableSizes.children.length > 0) {
        var sizes = "";
        var prices = "";
        var ancestry = availableSizes.children;
        var i;
        for (i = 0; i < ancestry.length; i++) {
            var size = ancestry[i].children[0].children[0].children[0].innerHTML;
            var price = ancestry[i].children[0].children[1].value;
            sizes += ',' + size;
            prices += ',' + price;
            console.log(sizes, prices);
        }
    } else {
        var size = document.getElementById('itemSize').value;
        var price = document.getElementById('itemPrice').value;
    }
    var taxable = document.getElementById('itemTaxable').value;
    var description = document.getElementById('itemDescription').value;
    var category = document.getElementById('itemCategory').value;
    if (sizes && prices) {
        var data = {
            'type': 'new-item',
            'name': name,
            'ndc': ndc,
            'available_sizes': sizes,
            'available_prices': prices,
            'strength': strength,
            'taxable': taxable,
            'description': description,
            'category': category
        };
    } else {
        var data = {
            'type': 'new-item',
            'name': name,
            'ndc': ndc,
            'price': price,
            'size': size,
            'strength': strength,
            'taxable': taxable,
            'description': description,
            'category': category
        };
    }
    const addItemBtn = document.querySelector('#addItem');
    addItemBtn.setAttribute('disabled', 'true');
    $('#addItem').html('Adding...');
    addDataToFirestore(data);
}


// SEARCH AN ITEM


/// Primary function
function searchItem() {
    var value = document.querySelector('searchItem').value;
    // console.log('search triggered', value);
    
    $('.item-row-body').hide();
    
    var input = value.toLowerCase();
    var itemList = document.getElementsByClassName('item-name');
    
    // var items = [];
    for (i = 0; i < itemList.length; i++) {
        var id = itemList[i].id;
        var name = document.querySelector(id).text().toLowerCase();
        
        if (input.include(name) || name.include(input)) {
            // items.push(itemList[i]);
            // var result = document.getElementById(id.split('-')[1]);
            $('#' + id.split('-')[1]).show();
        }
    }
    
}

// ORDERS

// Toggle order status
function getStatus(status) {
    switch (status) {
        case "pending":
            return "in preparation";
            break;
        case "in preparation":
            return "order ready";
            break;
        default:
            return "not prepared"
    }
}
function toggleStatus(elem) {
    var doc_id = elem.id.split('_')[1];
    var prevStatus = $('#status-' + doc_id).text();
    var newStatus = getStatus(prevStatus);
    var data = {
        "doc_id": doc_id,
        "type": 'order-update',
        "status": newStatus
    };
    $('#toggle-status_' + doc_id).css('opacity', '0.7')
    .html('Loading...');
    addDataToFirestore(data);
}


// AUTHENTICATION

// Toggle auth forms
function toggleAuth(state) {
    if (state === "login") {
        $('#authenticationModal').html(`
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Signup</h5>
                <a class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true"><i class="fa fa-times-circle"></i></span>
                </a>
            </div>
            <div class="modal-body">
                <form onsubmit="signupShopper()" id="shopperSignupForm" data-remote="true">
                    <input type="email" class="form-control add-margin-bottom" placeholder="email" id="signupEmail">
                    <input type="password" class="form-control add-margin-bottom" placeholder="password" id="signupPassword">
                    <input type="text" class="form-control add-margin-bottom" placeholder="Phone number" id="signupPhone">
                    <input type="text" class="form-control add-margin-bottom" placeholder="Full address" id="signupAddress">
                    <button type="submit" class="btn btn-primary btn-block add-margin-bottom height-55" id="signupBtn" onclick="signupShopper()">
                        Signup
                    </button>
                </form>
                <p class="theme-blue text-center">
                   <a class="btn btn-link" onclick="toggleAuth('signup')">
                       Have an account? <span class="theme-color">Log in</span>
                   </a>
                </p>
            </div>
        `);
    } else {
        $('#authenticationModal').html(`
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Login</h5>
                <a class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true"><i class="fa fa-times-circle"></i></span>
                </a>
            </div>
            <div class="modal-body">
                <form onsubmit="loginShopper()" id="shopperLoginForm" data-remote="true">
                    <input type="email" class="form-control add-margin-bottom" placeholder="email" id="loginEmail">
                    <input type="password" class="form-control add-margin-bottom" placeholder="password" id="loginPassword">
                    <button type="submit" class="btn btn-primary btn-block add-margin-bottom height-55" id="loginBtn" onclick="loginShopper()">
                        Log in
                    </button>
                </form>
                <p class="theme-blue text-center">
                   <a class="btn btn-link" onclick="toggleAuth('login')">
                       New to Senzzu? <span class="theme-color">Signup</span>
                   </a>
                </p>
            </div>
        `);
    }
}

// Shopper signup

$('#shopperSignupForm').on('submit', function (event) {
    event.preventDefault();
    signupShopper();
});

function signupShopper() {
    const shopperEmail = document.querySelector('#signupEmail').value;
    const shopperPassword = document.querySelector('#signupPassword').value;
    const shopperAddress = document.querySelector('#signupAddress').value;
    const shopperPhone = document.querySelector('#signupPhone').value;
    
    $('#signupBtn').css('opacity', '0.7').html('Creating your account...');
    
    firebase.auth().createUserWithEmailAndPassword(shopperEmail, shopperPassword)
    .then((resp) => {
        var data = {
            "type": "update-shopper",
            "shopperEmail": shopperEmail,
            "shopperAddress": shopperAddress,
            "shopperPhone": shopperPhone,
            "shopperUID": resp.user.uid
        };
        
        addShopperDataToFirestore(data);
    })
    .catch(function(error) {
      
        var errorCode = error.code;
        var errorMessage = error.message;
      
        console.log(errorCode, errorMessage);
      
    });
}

// Shopper login

$('#shopperLoginForm').on('submit', function (event) {
    event.preventDefault();
    loginShopper();
});

function loginShopper() {
    const shopperEmail = document.querySelector('#loginEmail').value;
    const shopperPassword = document.querySelector('#loginPassword').value;
    
    $('#loginBtn').css('opacity', '0.7').html('Logging you in...');
    
    firebase.auth().signInWithEmailAndPassword(shopperEmail, shopperPassword)
    .catch(function(error) {
      
      var errorCode = error.code;
      var errorMessage = error.message;
      
      console.log(errorCode, errorMessage);
      
    });
}

// Shopper logout
function signOut() {
    firebase.auth().signOut().then(function() {
        window.location.replace('/');
    }, function(error) {
        console.error('Sign Out Error', error);
    });
}

// Shopper authState
function authState() {
    var data = {
        "authType": 'authState'
    };
    
    $.get('/firebase_authentication', { data: data });
}

// Shopper update
function updateShopper(uid) {
    const accountEmail = document.querySelector('#accountEmail').value;
    const accountPhone = document.querySelector('#accountPhone').value;
    const accountUID = document.querySelector('#accountID').value;
    const accountAddress = document.querySelector('#accountAddress').value;
    const AptNumber = document.querySelector('#accountAptNumber').value;
    const accountName = document.querySelector('#accountName').value;
    
    $('#updateShopperBtn').css('opacity', '0.7').html('Updating...');
    
    var data = {
        "type": "update-shopper",
        "shopperUID": accountUID,
        "shopperPhone": accountPhone,
        "shopperAddress": accountAddress,
        "shopperEmail": accountEmail,
        "shopperAptNumber": AptNumber,
        "shopperName": accountName
        
    };
    addShopperDataToFirestore(data);
}


function togglePickup(state=null) {
    $('#delivery-option').html(state);
    $.get('/change_delivery_type', { type: state });
    if (state === "pickup") {
        $('#deliveryDetailsCard').hide();
        $('#pickupLocation').show();
    } else {
        $('#pickupLocation').hide();
        $('#deliveryDetailsCard').show();
    }
}

function displayTimes() {
    $('#selectedTime').hide();
    $('#availableTimes').show();
    $('.hide-times').show()
    $('#selectTime').show();
}

function hideTimes() {
    $('#availableTimes').hide();
    $('#selectedTime').show();
    $('.hide-times').hide()
    $('#availableDays').hide();
}

function showDays() {
    $('#selectTime').hide();
    $('#availableDays').show();
}

function showHours() {
    $('#showHours').hide();
    $('#hoursAvailable').show();
}

function pickDay(elem, today=null) {
    var day = elem.children[0].innerHTML;
    $('#dayChosen').html(day);
    $('#day').html(day);
    $('#availableDays').hide();
    $('#selectTime').show();
    
    if (today) {
        $('.as-soon-as-possible').hide();
    } else {
        $('.as-soon-as-possible').show();
    }
}

function pickHour(elem) {
    var time = elem.children[0].innerHTML;
    $('#hourChosen').html(time);
    $('#time').html(time);
    $('#hoursAvailable').hide();
    $('#showHours').show();
}

function deleteSize(elem) {
    var id = elem.id;
    $('#sizeSample' + id).remove();
}

function selectSize(elem) {
    var id = elem.id.split('-')[0];
    var index = elem.id.split('-')[1]
    $('.choose-size').html('<i class="fa fa-check-circle light"></i>');
    elem.innerHTML = '<i class="fa fa-check-circle theme-green"></i>';
    var priceChosen = $('#priceChosen' + id + '-' + index).text();
    var sizeChosen = $('#sizeChosen' + id + '-' + index).text();
    console.log(priceChosen, sizeChosen);
    $('#item-price' + id).html(priceChosen);
    $('#item-size' + id).html(sizeChosen);
    $('#chosenSizePrice' + id).html('$' + priceChosen + ' - ' + sizeChosen);
}

function addSize() {
    var size = document.querySelector('#addSize');
    var sizeValue = size.value;
    var availableSizes = document.querySelector('#availableSizes');
    $('#availableSizes').append(`
        <div class="col-md-4" id=`+ 'sizeSample' + sizeValue.split(',')[0] + `>
            <div class="input-group mb-3">
                <div class="input-group-prepend">
                    <span class="input-group-text font-13 theme-background white">` + sizeValue.split(',')[0] + `</span>
                </div>
                <input class="form-control height-40 font-13" placeholder="Price">
                <div class="input-group-append">
                    <span class="input-group-text font-13 cursor-pointer" onclick="deleteSize(this)" id=` + sizeValue.split(',')[0] + `><i class="fa fa-times-circle"></i></span>
                </div>
            </div>
        </div>
    `);
    size.value = '';
}

function multipleSizes() {
    $('#oneSizeInput').hide();
    $('#multipleSizeText').hide();
    $('#oneSizePrice').hide();
    $('#multipleSizes').show();
    $('#oneSizeText').show()
}

function oneSize() {
    $('#oneSizeText').hide();
    $('#multipleSizes').hide();
    $('#oneSizeInput').show();
    $('#multipleSizeText').show();
    $('#oneSizePrice').show();
    $('#availableSizes').empty();
}

function goLive() {
    $('#order-processing-modal').show();
    $.get('/go_live');
}

function reorder() {
    
}
