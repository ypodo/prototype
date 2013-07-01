
function postAudio () {
	var path="http://"+window.location.host;
	applet.sendGongRequest('PostToForm', path+'/post.php', 'record', '', 'sound.wav');
  //alert("Data successfully posted !");
}
function recorderReloade(argument){
	// This function inmplemented in recorder partial	
}	
function play () {
  var time = applet.sendGongRequest('PlayMedia', 'sound.wav')
}
function record () {
  var duration = applet.sendGongRequest('RecordMedia', 'sound.wav')
}
function stop () {
  var duration = applet.sendGongRequest('StopMedia', 'sound.wav')
}

 $("form[data-remote]").each(function(i, form){
        var f = $(form)
        var loading = $("<div class='form_loading'></div>"),
            notice  = $("<div class='form_notice'></div>"),
            errors  = $("<ul class='form_errore'></ul>");
        
        f.append(loading.hide())
        f.prepend(notice.hide())
        f.prepend(errors.hide())
            
        // hide errors and notice and show loading indicator when loading
        f.bind("ajax:loading", function(){ 
            errors.hide(); 
            notice.hide(); 
            loading.show();
        })
        // hide loading indicator when finished
        f.bind("ajax:complete", function() { 
            loading.hide(); 
        })
        // show notice on success
        f.bind("ajax:success", function(ev, data, status, xhr){ 
            notice.text(data).show(); 
        })
        // show errors on failure
        f.bind("ajax:failure", function(ev, xhr, status){
            errors.html("")
            $.parseJSON(xhr.responseText).forEach(function(msg){
                errors.append("<li>" + msg + "</li>")
            })
            errors.show()
        })
    })
 
function doAxaj(msg)
{ 		
	//This function works by timer 
	//msg from 0 to 100
	//work only when #tab4 active
	msg = msg || 0;
	if($('#tab4').attr("class")=="tab-pane active"){		
		document.getElementById("progress_bar").style.width= msg+"%";		
		document.getElementById("progress_bar_lable").innerHTML = "<center>Progress status: "+msg+" % completed</center>";
		update_report_table();
		if(msg == "100"){
	 		return; 		
	 	}
	 	//update_report_table() by executing ajax;
	  	setTimeout(progress_bar, 20000); //wait 20 seconds before continuing	
	}
	
}
function can_start(mode){
	//1. ask server about all requerment before start could be started
	//document.getElementById("green_submit").disabled=true;	
	var can_start=$.ajax(window.location.pathname+"/can_start").done(function(){
		if(can_start.responseText=="false"){			
				$("#notification").show();
				var elem=$('.control-list[style="background-color: #EEEEEE"]');
				elem.css("background-color","red");
				return false;
			}
						
		else{	
				//Starting calling process
				document.getElementById("green_submit").disabled=true;
				var elem=$('.control-list[style="background-color: red;"]');
				elem.css("background-color","#eeeeee");
				$(".alert").alert('close');						
				checkout(mode);	
			}
				
		}		
	);
	
}

function progress_bar()
{
   //calling server axaj action
	$.ajax({
	type: "POST",
	url: window.location.pathname+"/ajax_progress_call", // user controller
	}).done(function(msg){
	doAxaj(msg);
	});
}
function update_report_table()
{
   //axaj report
	$.ajax({
			type: "POST",
			url: window.location.pathname+"/ajax_report"
			}).done(function(msg){
			document.getElementById("full_report_table_body").innerHTML=msg;
		});		
}
function refresh_report_sum(argument) {
  //axaj report
	$.ajax({
			type: "POST",
			url: window.location.pathname+"/ajax_report_sum"
			}).done(function(msg){
			document.getElementById("report_tbl").innerHTML=msg;
		});
}
function sendReport(argument){ // This function not works
	var addr=document.getElementById("appendedInputButton").value;
	if(addr == ""){
		return;
	}
	$.post("/ajax_report_mail/", { mail: '"'+addr+'"'})
	.done(function(data) {
		alert("Mail sent: "+addr);			 
		document.getElementById("flash_field"); 
	});
}
function tab2 () {
	// Go to tab2
   $('#mainTabs a[href="#tab2"]').tab('show');
}
function tab1 () {
	// Go to tab1
   $('#mainTabs a[href="#tab1"]').tab('show');
}
function tab3 () {
	// Go to tab3
   $('#mainTabs a[href="#tab3"]').tab('show');
}
function tab4 () {
	// Go to tab4
   $('#mainTabs a[href="#tab4"]').tab('show');
}
$('#mainTabs a').click(function (e) {
  alert(this);
})

function agreementValid(){
	
	if(!document.getElementById("agreement").checked){
		document.getElementById('agreementText').setAttribute("style", "color: red;");
	}
	else{
		
		document.getElementById('agreementText').setAttribute("style");
	}
}
function add_invite_ajax(argument) {
	var debug;
	if($("#invite_name").val()!="" && $("#invite_number").val()!=""){		
		var respons=$.ajax({
		url:"/invites",
		type:"POST",
		data:$("#ajax_trigger").serialize()	
			}).done(function() {  
				//$("#inviteT_tbl").append(respons.responseText);
				append_data_invite_table(respons);
				total_invites_counter(1);
			});
		return respons;
		}
	return false;   
}
function total_invites_counter (argument) {
	if(argument >0){
		var i=document.getElementById("total_invites").innerHTML.split(":")[1];
		i++;
		document.getElementById("total_invites").innerHTML="Total invites: "+i;
		document.getElementById("payments").innerHTML="nis: "+(unit_price*i).toFixed(2);
	}
	else if(argument <0){
		var i=document.getElementById("total_invites").innerHTML.split(":")[1];
		i--;
		document.getElementById("total_invites").innerHTML="Total invites: "+i;
		document.getElementById("payments").innerHTML="nis: "+(unit_price*i).toFixed(2);		
	}
  
}
function append_data_invite_table (argument) {
	if(argument !=null){
		$('#inviteT_tbl tbody tr:nth-child(' + 2 + ')').after('<tr><td>'+JSON.parse(argument.responseText).name+'</td><td>'+JSON.parse(argument.responseText).mail+'</td><td>'+JSON.parse(argument.responseText).number+'</td><td style="color: orange"><a href="/invites/'+JSON.parse(argument.responseText).id+'" class="label label-important" data-method="delete" el="nofollow" onclick="delete_invite_ajax('+JSON.parse(argument.responseText).id+');" id="'+JSON.parse(argument.responseText).id+'" data-remote="true">Destroy</a></td></tr>');	
		clean_invite_inputs();		
	return true;
	}
  
}
function clean_invite_inputs (argument) {
  	document.getElementById("invite_name").value=""
  	document.getElementById("invite_number").value=""
  	document.getElementById("invite_mail").value=""
}
function delete_invite_ajax (argument) {  
   var row=document.getElementById(argument).parentElement.parentElement;
   $(row).remove();
   total_invites_counter(-1);
}
function remove_all_invites(argument){
	var r=confirm("Remove all?")
	if (r==true)
	  {
	  	$.ajax("/invites/delete_all")
	  	delete_all_invites_html_table();
	  }
	else
	  {
	  	alert("You pressed Cancel!")
	  }	
}
function delete_all_invites_html_table(argument) {
	for(var i=document.getElementById("inviteT_tbl").rows.length;i>=3;i--){
		document.getElementById("inviteT_tbl").deleteRow(i-1);			
	};
	document.getElementById("total_invites").innerHTML="Total invites: 0"
	var i=document.getElementById("total_invites").innerHTML.split(":")[1];
	document.getElementById("payments").innerHTML="nis: "+(unit_price*i).toFixed(2);
	
}
function checkout (argument) {  
  //to do
  if(argument=="prod" || argument==""||argument==null){
  	var respons=$.ajax({
		url:"/orders/checkout",
		type:"POST",
		data:$("#ajax_trigger").serialize()	
			}).done(function() {				
				//alert(respons.responseText);
				dg.startFlow(respons.responseText);
				post_payment_process();				
				document.getElementById("green_submit").disabled=false;				
				});	
  } 
  else if (argument=="dev") {
  	var respons=$.ajax({
		url:"/dev_order/checkout",
		type:"POST",
		data:$("#ajax_trigger").serialize()	
			}).done(function() {				
				//alert(respons.responseText);
				dg.startFlow(respons.responseText);
				post_payment_process();				
				document.getElementById("green_submit").disabled=false;				
				});
  };
  
				
}
function post_payment_process(argument) {
	 // add relevant message above or remove the line if not required	
	if(dg.isOpen() == false){
              //alert("post_payment_process");
              tab4();
              top.dg.closeFlow();
              tab_data_sync("#tab4");
              return              
	 }
	 timer1();         
}                             


function timer1(){ setTimeout('post_payment_process()',2000);	}

function tab_data_sync(argument) {
	switch(argument){
		case "#tab3":
			$.post(window.location.href+"/ajax_payment_details")
				.done(function(data) {
				  //alert("Data Loaded: " + data);
				  document.getElementById('payment_details').innerHTML=data;
				});
		break;
		
		case "#tab4":
			progress_bar();	
			refresh_report_sum();		
		break;
		
		case "#tab2":
		break;
		
		case "#tab1":
		break;
		
		default:
		return null;
	}  
    
}

function show_history_invites_by_token(argument) {
//This function will get invite_history from history_controlle where token == argument
// and show it on /history/show page

	var respons=$.ajax({
		url:"/history/show/"+argument, //see the route
		type:"POST",
		data:$("#ajax_trigger").serialize()	
			}).done(function() {
				//whait for response
				//do
				document.getElementById("tbl_invitesHistory").innerHTML=respons.responseText;
				
				});
}
function check_google_translate_bar (argument) {
  setTimeout(hide_google_frame, 3000);  
}
function hide_google_frame (argument) {
  try{ 
  	document.getElementById(":2.container").remove();
  }
  catch(err) {}
}

function fadeOutFlashArea() { 
  setTimeout(function() {
    $(function() {
       $('#flash_field').delay(1000).fadeIn('normal', function() {
         $(this).delay(2500).fadeOut();
       });  
     });
   }, 1000);   
};
