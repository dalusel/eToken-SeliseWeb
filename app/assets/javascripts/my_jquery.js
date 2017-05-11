var html_forInstitutionType = $('.my_InstitutionType').html();
var html_forPlace=$('.my_Place').html();
var isClearToken

window.onload = function() {
    if(html_forInstitutionType == null)
        html_forInstitutionType = $('.my_InstitutionType').html();
    if(html_forPlace == null)
        html_forPlace=$('.my_Place').html();
    isClearToken = false;
    setDefaultData();
    requestDateFormating();
    enableBooking();
    isClearToken = true;   
}

function setDefaultData()
{
    if(gon.Institution != null) {
        $(".my_Institution").val(gon.Institution).trigger("change");
        $(".my_InstitutionType").prop('disabled', false);
    }
    else {
        $(".my_Institution").val("");
        $(".my_InstitutionType").prop('disabled', true);
    }

    if(gon.InstitutionType != null) {
        $(".my_InstitutionType").val(gon.InstitutionType).trigger("change");
        $(".my_Place").prop('disabled', false);
    }
    else
    {
        $(".my_InstitutionType").val("");
        $(".my_Place").prop('disabled', true);
    }

    if(gon.Place !=null )
    {
        $(".my_Place").val(gon.Place).trigger("change");;
        $(".my_Search").prop('disabled', false);
    }
    else {
        $(".my_Place").val("");
        $(".my_Search").prop('disabled', true);
    }

    $(".my_Name").val(gon.Name);
    $(".my_PhoneNo").val(gon.PhoneNo);

    if(gon.ETokenID != null)
    {   
          $(".my_EID").val(gon.ETokenID);       
    }
    $(".my_CancelToken").prop('disabled', true);
    if(gon.isButtonClick == false)
        $(".my_Display").hide();
    $(".my_CreateNew").hide()
}

$(document).on("change", ".my_Institution", function(e){
    onInstitution_Change()
    $(".my_InstitutionType").val("");
    $(".my_Place").val("");
    $(".my_InstitutionType").prop('disabled', false);
    $(".my_Place").prop('disabled', true);
    $(".my_Search").prop('disabled', true);
    $(".my_Display").hide();
    clearTokenDetails();
    $(".my_RequestToken").prop('disabled', true);
})

function onInstitution_Change()
{
    var institutiontype
    if(html_forInstitutionType ==null) {
        institutiontype = $('.my_InstitutionType').html();
    }
    else {
        institutiontype = html_forInstitutionType;
    }
    var institution = $('.my_Institution :selected').text();
    var options = $(institutiontype).filter("optgroup[label='"+institution+"']").html();    
    if (options) {
        $('.my_InstitutionType').html(options)
    }
    else {
        $('.my_InstitutionType').empty()
    }
}

$(document).on("change", ".my_InstitutionType", function(e){
    onInstitutionType_Change();
    $(".my_Place").val("");
    $(".my_Place").prop('disabled', false);
    $(".my_Search").prop('disabled', true);
    $(".my_Display").hide();
    clearTokenDetails();
    $(".my_RequestToken").prop('disabled', true);
})

function onInstitutionType_Change()
{
    var place
    if(html_forPlace==null) {
        place = $('.my_Place').html();
    }
    else {
        place = html_forPlace;
    }
    var institutionType = $('.my_InstitutionType :selected').text();
    var options = $(place).filter("optgroup[label='"+institutionType+"']").html();
    if (options) {
        $('.my_Place').html(options);
    }
    else {
        $('.my_Place').empty();
    }
}

$(document).on("change", ".my_Place", function(e){
    $(".my_Search").prop('disabled', false);
    $(".my_Display").show();
    searchReseult();
    clearTokenDetails()
    $(".my_RequestToken").prop('disabled', true);
 })

//Validate correct phone No i.e.. allow phoneNo to start with 1 or 7 and should have 8 digits
$(document).on("keypress",".my_PhoneNo", function(e) {
    if (e.keyCode >= 48 && e.keyCode <= 57) {
        var phoneNo = $(".my_PhoneNo").val()
        if (phoneNo.length == 0) {
            if (e.keyCode == 49 || e.keyCode == 55)
                return true;
            else {
                alert("Please try to enter valid PhoneNo")
                return false
            }

        }
        else if (phoneNo.length == 8) {
            alert("Please try to enter valid PhoneNo")
            return false
        }
        return true;
    }
    else {
        return false;
    }
})

//Request Date Formating
function requestDateFormating(){
    var curDate = new Date();
    curDate.setDate(curDate.getDate() + 1);
    var curr_day = curDate.getDate();
    var curr_month = curDate.getMonth();
    var curr_year = curDate.getFullYear();
    var myDateFormat = curr_day+"/"+ curr_month+"/"+curr_year;
    $(".my_RequestDate").val(myDateFormat);
    $(".my_RequestDate").prop('disabled', true);
}

function searchReseult()
{
    gon.Institution =  $(".my_Institution").val();
    gon.InstitutionTye = $(".my_InstitutionType").val();
    gon.Places =$(".my_Place").val();
    $('.my_totalToken').text(gon.totalToken);
    $('.my_usedToken').text(gon.usedToken);
    $('.my_availableToken').text(gon.availableToken);
    $('.my_tokenNo').text(gon.yourTokenNo);
    $('.my_timeToCollect').text(gon.tokenTime);
    $('.my_EID').text(gon.ETokenID)
    if(gon.availableToken >  0)
        $(".my_Name").prop('disabled', false);
}

function enableBooking()
{
    if(gon.availableToken > 0)
        $(".my_RequestToken").prop('disabled', false);
    else
        $(".my_RequestToken").prop('disabled', true);
    if(gon.yourTokenNo > 0 && gon.errorCount == 0) {
        $(".my_Institution").prop('disabled', true);
        $(".my_InstitutionType").prop('disabled', true);
        $(".my_Place").prop('disabled', true);
        $(".my_Search").prop('disabled', true);
        $(".my_Name").prop('disabled', true);
        $(".my_PhoneNo").prop('disabled', true);
        $(".my_RequestToken").prop('disabled', true);
        $(".my_CancelToken").prop('disabled', false);
        $(".my_CreateNew").show()
    }
}

function clearTokenDetails()
{
    if(isClearToken == true) {
        $('.my_totalToken').text("");
        $('.my_usedToken').text("");
        $('.my_availableToken').text("");
        $('.my_tokenNo').text("");
        $('.my_timeToCollect').text("");
    }
}
