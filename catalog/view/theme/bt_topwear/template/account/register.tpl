<?php echo $header; ?>
 <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
	<?php if($breadcrumb == end($breadcrumbs)){ ?>
		<a class="last" href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
	<?php }else{ ?>
		<a href="<?php echo $breadcrumb['href']; ?>"><span><?php echo $breadcrumb['text']; ?></span></a>
    <?php } ?>
    <?php } ?>
</div>
<?php if ($error_warning) { ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php //echo $column_left; ?><?php //echo $column_right; ?>
<div id="content"><?php echo $content_top; ?>
 <div class="register_fr">
  <h1><?php echo $heading_title; ?></h1>
  <p><?php echo $text_account_already; ?></p>
  <form class="register" action="<?php echo $action; ?>" method="post" enctype="multipart/form-data">
    <div class="left">
	<h2><?php echo $text_your_details; ?></h2>
    <div class="content">
      <table class="form">
        <tr>
          <td><?php echo $entry_firstname; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="firstname" value="<?php echo $firstname; ?>" />
            <?php if ($error_firstname) { ?>
            <span class="error"><?php echo $error_firstname; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_lastname; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="lastname" value="<?php echo $lastname; ?>" />
            <?php if ($error_lastname) { ?>
            <span class="error"><?php echo $error_lastname; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_gender; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><select name="gender_id">
              <option value=""><?php echo $text_select; ?></option>
              <?php foreach ($genders as $gender) { ?>
              <?php if ($gender['gender_id'] == $gender_id) { ?>
              <option value="<?php echo $gender['gender_id']; ?>" selected="selected"><?php echo $gender['gender']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $gender['gender_id']; ?>"><?php echo $gender['gender']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
            <?php if ($error_gender) { ?>
            <span class="error"><?php echo $error_gender; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_email; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="email" value="<?php echo $email; ?>" />
            <?php if ($error_email) { ?>
            <span class="error"><?php echo $error_email; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_telephone; ?><span class="required">*</span></td>
		</tr>
        <tr>
          <td><input type="text" name="telephone" value="<?php echo $telephone; ?>" />
            <?php if ($error_telephone) { ?>
            <span class="error"><?php echo $error_telephone; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_date_of_birth; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="date_of_birth" value="<?php echo $date_of_birth; ?>" />
            <?php if ($error_telephone) { ?>
            <span class="error"><?php echo $error_date_of_birth; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_ethnic; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="ethnic" value="<?php echo $ethnic; ?>" />
            <?php if ($error_ethnic) { ?>
            <span class="error"><?php echo $error_ethnic; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><?php echo $entry_fax; ?></td>
		</tr>
		<tr>
          <td><input type="text" name="fax" value="<?php echo $fax; ?>" /></td>
        </tr>
      </table>
    </div>
    
    <!-- /////////// END “you-id” - “your-name” modifications/////////////
        /////////////////////// Modification//////////////////////
        //       ID: 1051018	 	 	 	 	
        //       Name: Tran Thanh Toan	 	 	 	 	
        // 	 Class: 10CTT 
        // 	 Date 1/1/2014
        // 	 Description: add textbox password
        // 	 Date modified: 1/1/2014 
        // 	 Last updated: list the change by line number and goal, ex: 
        //	 	 + line 289: optimize the operation
        /////////// Start “you-id” - “your-name” modifications///////////// -->
    
    <h2 class="password"><?php echo $text_id; ?></h2>
    <div class="content">
      <table class="form">
        <tr>
          <td> <?php echo $entry_idnum; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="idnum" value="<?php echo $idnum; ?>" />
            <?php if ($error_idnum) { ?>
            <span class="error"><?php echo $error_idnum; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_iddate; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="iddate" value="<?php echo $iddate; ?>" />
            <?php if ($error_iddate) { ?>
            <span class="error"><?php echo $error_iddate; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_idlocation; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td>
          <select name="id_location">
              
            </select>
            <?php if ($error_id_location) { ?>
            <span class="error"><?php echo $error_id_location; ?></span>
            <?php } ?>
          </td>
        </tr>
      </table>
    </div>
    <!-- end -->
    
	</div>
    <div class="right">
	<h2><?php echo $text_your_address; ?></h2>
    <div class="content">
      <table class="form">
      
      <!-- start -->
       <!-- <tr>
          <td><?php echo $entry_company; ?></td>
		</tr>
		<tr>
          <td><input type="text" name="company" value="<?php echo $company; ?>" /></td>
        </tr>        
        <tr style="display: <?php echo (count($customer_groups) > 1 ? 'table-row' : 'none'); ?>;">
          <td><?php echo $entry_customer_group; ?></td>
          <td><?php foreach ($customer_groups as $customer_group) { ?>
            <?php if ($customer_group['customer_group_id'] == $customer_group_id) { ?>
            <input type="radio" name="customer_group_id" value="<?php echo $customer_group['customer_group_id']; ?>" id="customer_group_id<?php echo $customer_group['customer_group_id']; ?>" checked="checked" />
            <label for="customer_group_id<?php echo $customer_group['customer_group_id']; ?>"><?php echo $customer_group['name']; ?></label>
            <br />
            <?php } else { ?>
            <input type="radio" name="customer_group_id" value="<?php echo $customer_group['customer_group_id']; ?>" id="customer_group_id<?php echo $customer_group['customer_group_id']; ?>" />
            <label for="customer_group_id<?php echo $customer_group['customer_group_id']; ?>"><?php echo $customer_group['name']; ?></label>
            <br />
            <?php } ?>
            <?php } ?></td>
        </tr>      
        <tr id="company-id-text">
          <td><span id="company-id-required" class="required">*</span> <?php echo $entry_company_id; ?></td>
		</tr>
		<tr  id="company-id-display">
          <td><input type="text" name="company_id" value="<?php echo $company_id; ?>" />
            <?php if ($error_company_id) { ?>
            <span class="error"><?php echo $error_company_id; ?></span>
            <?php } ?></td>
        </tr>
        <tr id="tax-id-display">
          <td><span id="tax-id-required" class="required">*</span> <?php echo $entry_tax_id; ?></td>
          <td><input type="text" name="tax_id" value="<?php echo $tax_id; ?>" />
            <?php if ($error_tax_id) { ?>
            <span class="error"><?php echo $error_tax_id; ?></span>
            <?php } ?></td>
        </tr>-->
        
        <!-- end -->
        
        <!-- /////////// END “you-id” - “your-name” modifications/////////////
        /////////////////////// Modification//////////////////////
        //       ID: 1051018	 	 	 	 	
        //       Name: Tran Thanh Toan	 	 	 	 	
        // 	 Class: 10CTT 
        // 	 Date 1/1/2014
        // 	 Description: update student id for NK (NK+ iddb)
        // 	 Date modified: 1/1/2014 
        // 	 Last updated: list the change by line number and goal, ex: 
        //	 	 + line 289: optimize the operation
        /////////// Start “you-id” - “your-name” modifications///////////// -->
        <tr>
          <td> <?php echo $entry_university; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><select name="university_id">
              <option value="-1"><?php echo $text_select; ?></option>
              <?php foreach ($universities as $university) { ?>
              <?php if ($university['category_id'] == $university_id) { ?>
              <option value="<?php echo $university['category_id']; ?>" selected="selected"><?php echo $university['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $university['category_id']; ?>"><?php echo $university['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
            <?php if ($error_university) { ?>
            <span class="error"><?php echo $error_university; ?></span>
            <?php } ?></td>
        </tr>
         <tr>
          <td> <?php echo $entry_faculty; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><select name="faculty_id">
              
            </select>
            <?php if ($error_faculty) { ?>
            <span class="error"><?php echo $error_faculty; ?></span>
            <?php } ?></td>
        </tr>
        <tr id="studentidblock_head">
          <td> <?php echo $entry_student_id; ?><span class="required">*</span></td>
		</tr>
		<tr id="studentidblock_tail">
          <td><input type="text" name="student_id" value="<?php echo $student_id; ?>" />
            <?php if ($error_student_id) { ?>
            <span class="error"><?php echo $error_student_id; ?></span>
            <?php } ?></td>
        </tr>
        <!-- end -->
        
        <tr>
          <td> <?php echo $entry_address_1; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="address_1" value="<?php echo $address_1; ?>" />
            <?php if ($error_address_1) { ?>
            <span class="error"><?php echo $error_address_1; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><?php echo $entry_address_2; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="text" name="address_2" value="<?php echo $address_2; ?>" />
          	<?php if ($error_address_2) { ?>
            <span class="error"><?php echo $error_address_2; ?></span>
            <?php } ?></td>
        </tr>
        <!-- start -->
        
		<!--<tr>
          <td> <?php echo $entry_city; ?><span class="required">*</span></td>
		</tr>
        <tr>
          <td><input type="text" name="city" value="<?php echo $city; ?>" />
            <?php if ($error_city) { ?>
            <span class="error"><?php echo $error_city; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span id="postcode-required" class="required">*</span> <?php echo $entry_postcode; ?></td>
		</tr>
		<tr>
          <td><input type="text" name="postcode" value="<?php echo $postcode; ?>" />
            <?php if ($error_postcode) { ?>
            <span class="error"><?php echo $error_postcode; ?></span>
            <?php } ?></td>
        </tr>-->
        
        <!-- end -->
        
        <tr>
          <td> <?php echo $entry_country; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><select name="country_id">
              <option value=""><?php echo $text_select; ?></option>
              <?php foreach ($countries as $country) { ?>
              <?php if ($country['country_id'] == $country_id) { ?>
              <option value="<?php echo $country['country_id']; ?>" selected="selected"><?php echo $country['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $country['country_id']; ?>"><?php echo $country['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
            <?php if ($error_country) { ?>
            <span class="error"><?php echo $error_country; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_zone; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><select name="zone_id">
            </select>
            <?php if ($error_zone) { ?>
            <span class="error"><?php echo $error_zone; ?></span>
            <?php } ?></td>
        </tr>
      </table>
    </div>
    
    <h2 class="password"><?php echo $text_your_password; ?></h2>
    <div class="content">
      <table class="form">
        <tr>
          <td> <?php echo $entry_password; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="password" name="password" value="<?php echo $password; ?>" />
            <?php if ($error_password) { ?>
            <span class="error"><?php echo $error_password; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td> <?php echo $entry_confirm; ?><span class="required">*</span></td>
		</tr>
		<tr>
          <td><input type="password" name="confirm" value="<?php echo $confirm; ?>" />
            <?php if ($error_confirm) { ?>
            <span class="error"><?php echo $error_confirm; ?></span>
            <?php } ?></td>
        </tr>
      </table>
    </div>
    
	</div>
	<div class="left newsletter">
    <div class="content">
	<h2 class="newsletter"><?php echo $text_newsletter; ?></h2>
      <table class="form register_last">
        <tr>
          <td  class="subscribe"><?php echo $entry_newsletter; ?></td>
          <td class="input"><?php if ($newsletter) { ?>
            <input type="radio" name="newsletter" value="1" checked="checked" />
            <span><?php echo $text_yes; ?></span>
            <input type="radio" name="newsletter" value="0" />
            <span><?php echo $text_no; ?></span>
            <?php } else { ?>
            <input type="radio" name="newsletter" value="1" />
            <span><?php echo $text_yes; ?></span>
            <input type="radio" name="newsletter" value="0" checked="checked" />
            <span><?php echo $text_no; ?></span>
            <?php } ?></td>
        </tr>
      </table>
    </div>
	</div>
    <?php if ($text_agree) { ?>
    <div class="buttons">
      <div class="left">
        <?php if ($agree) { ?>
        <input type="checkbox" name="agree" value="1" checked="checked" />
        <?php } else { ?>
        <input type="checkbox" name="agree" value="1" />
        <?php } ?>&nbsp;<?php echo $text_agree; ?></br></br></br>
        <span class="button_fr_ip"><input type="submit" value="<?php echo $button_continue; ?>" class="button cst" /></span>
      </div>
    </div>
    <?php } else { ?>
    <div class="buttons">
      <div class="left">
        <span class="button"><input type="submit" value="<?php echo $button_continue; ?>" class="button" /></span>
      </div>
    </div>
    <?php } ?>
  </form>
  <?php echo $content_bottom; ?></div></div>
<script type="text/javascript"><!--
$('input[name=\'customer_group_id\']:checked').live('change', function() {
	var customer_group = [];
	
<?php foreach ($customer_groups as $customer_group) { ?>
	customer_group[<?php echo $customer_group['customer_group_id']; ?>] = [];
	customer_group[<?php echo $customer_group['customer_group_id']; ?>]['company_id_display'] = '<?php echo $customer_group['company_id_display']; ?>';
	customer_group[<?php echo $customer_group['customer_group_id']; ?>]['company_id_required'] = '<?php echo $customer_group['company_id_required']; ?>';
	customer_group[<?php echo $customer_group['customer_group_id']; ?>]['tax_id_display'] = '<?php echo $customer_group['tax_id_display']; ?>';
	customer_group[<?php echo $customer_group['customer_group_id']; ?>]['tax_id_required'] = '<?php echo $customer_group['tax_id_required']; ?>';
<?php } ?>	

	if (customer_group[this.value]) {
		if (customer_group[this.value]['company_id_display'] == '1') {
			$('#company-id-display').show();
		} else {
			$('#company-id-display').hide();
		}
		
		if (customer_group[this.value]['company_id_required'] == '1') {
			$('#company-id-required').show();
		} else {
			$('#company-id-required').hide();
		}
		
		if (customer_group[this.value]['tax_id_display'] == '1') {
			$('#tax-id-display').show();
		} else {
			$('#tax-id-display').hide();
		}
		
		if (customer_group[this.value]['tax_id_required'] == '1') {
			$('#tax-id-required').show();
		} else {
			$('#tax-id-required').hide();
		}	
	}
});

$('input[name=\'customer_group_id\']:checked').trigger('change');
//--></script> 
<script type="text/javascript"><!--
$('select[name=\'country_id\']').bind('change', function() {
	$.ajax({
		url: 'index.php?route=account/register/country&country_id=' + this.value,
		dataType: 'json',
		beforeSend: function() {
			$('select[name=\'country_id\']').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
		},
		complete: function() {
			$('.wait').remove();
		},			
		success: function(json) {
			if (json['postcode_required'] == '1') {
				$('#postcode-required').show();
			} else {
				$('#postcode-required').hide();
			}
			
			html = '<option value=""><?php echo $text_select; ?></option>';
			
			if (json['zone'] != '') {
				for (i = 0; i < json['zone'].length; i++) {
        			html += '<option value="' + json['zone'][i]['zone_id'] + '"';
	    			
					if (json['zone'][i]['zone_id'] == '<?php echo $zone_id; ?>') {
	      				html += ' selected="selected"';
	    			}
	
	    			html += '>' + json['zone'][i]['name'] + '</option>';
				}
			} else {
				html += '<option value="0" selected="selected"><?php echo $text_none; ?></option>';
			}
			
			$('select[name=\'zone_id\']').html(html);
			
			<!-- start /////////// END “you-id” - “your-name” modifications/////////////
        /////////////////////// Modification//////////////////////
        //       ID: 1051018	 	 	 	 	
        //       Name: Tran Thanh Toan	 	 	 	 	
        // 	 Class: 10CTT 
        // 	 Date 1/1/2014
        // 	 Description: add select box
        // 	 Date modified: 1/1/2014 
        // 	 Last updated: list the change by line number and goal, ex: 
        //	 	 + line 289: optimize the operation
        /////////// Start “you-id” - “your-name” modifications/////////////-->
			html_id_location = '<option value=""><?php echo $text_select; ?></option>';
			
			if (json['zone'] != '') {
				for (i = 0; i < json['zone'].length; i++) {
        			html_id_location += '<option value="' + json['zone'][i]['zone_id'] + '"';
	    			
					if (json['zone'][i]['zone_id'] == '<?php echo $id_location; ?>') {
	      				html_id_location += ' selected="selected"';
	    			}
	
	    			html_id_location += '>' + json['zone'][i]['name'] + '</option>';
				}
			} else {
				html_id_location += '<option value="0" selected="selected"><?php echo $text_none; ?></option>';
			}
			
			$('select[name=\'id_location\']').html(html_id_location);
			<!-- end -->
		},
		error: function(xhr, ajaxOptions, thrownError) {
			alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
		}
	});
});

$('select[name=\'country_id\']').trigger('change');

<!-- /////////// END “you-id” - “your-name” modifications/////////////
        /////////////////////// Modification//////////////////////
        //       ID: 1051018	 	 	 	 	
        //       Name: Tran Thanh Toan	 	 	 	 	
        // 	 Class: 10CTT 
        // 	 Date 1/1/2014
        // 	 Description: add textbox NK
        // 	 Date modified: 1/1/2014 
        // 	 Last updated: list the change by line number and goal, ex: 
        //	 	 + line 289: optimize the operation
        /////////// Start “you-id” - “your-name” modifications///////////// -->
var nkid = '<?php echo $NKUniversity ?>';
$('select[name=\'university_id\']').bind('change', function() {
	$.ajax({
		url: 'index.php?route=account/register/childcategory&university_id=' + $('select[name=\'university_id\']').val(),
		dataType: 'json',
		beforeSend: function() {
			$('select[name=\'university_id\']').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
		},
		complete: function() {
			$('.wait').remove();
		},			
		success: function(json) {
			
			html = '<option value=""><?php echo $text_select; ?></option>';
			if (json) {
				for (i = 0; i < json.length; i++) {
        			html += '<option value="' + json[i]['faculty_id'] + '"';
	    			
					if (json[i]['faculty_id'] == '<?php echo $faculty_id; ?>') {
	      				html += ' selected="selected"';
	    			}
	
	    			html += '>' + json[i]['name'] + '</option>';
				}
			} else {
				html += '<option value="0" selected="selected"><?php echo $text_none; ?></option>';
			}
			
			$('select[name=\'faculty_id\']').html(html);
			
		},
		error: function(xhr, ajaxOptions, thrownError) {
			alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
		}
	});
	//check Nang Khieu
	if($('select[name=\'university_id\']').val() == nkid) {
		var timestamp = +new Date();
		$('tr[id^=\'studentidblock_\']').hide();
		$('input[name=\'student_id\']').val('NK'+ timestamp.toString().substr(0,8));
		$('input[name=\'student_id\']').attr("readonly","readonly");
	}
	else{
		$('tr[id^=\'studentidblock_\']').show();
		$('input[name=\'student_id\']').val('');
		$('input[name=\'student_id\']').removeAttr("readonly");
	}
});

$('select[name=\'university_id\']').trigger('change');
<!--/////////// END “you-id” - “your-name” modifications/////////////
        /////////////////////// Modification//////////////////////
        //       ID: 1051018	 	 	 	 	
        //       Name: Tran Thanh Toan	 	 	 	 	
        // 	 Class: 10CTT 
        // 	 Date 1/1/2014
        // 	 Description: update student id for NK (NK+ iddb)
        // 	 Date modified: 1/1/2014 
        // 	 Last updated: list the change by line number and goal, ex: 
        //	 	 + line 289: optimize the operation
        /////////// Start “you-id” - “your-name” modifications/////////////-->
//--></script> 
<script type="text/javascript"><!--
$(document).ready(function() {
	$('.colorbox').colorbox({
		width: '80%', 
		height: '80%',
		maxWidth: 640,
        maxHeight: 480
	});
});
//--></script>  
<?php echo $footer; ?>