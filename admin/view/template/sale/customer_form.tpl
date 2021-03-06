<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/customer.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a href="<?php echo $cancel; ?>" class="button"><?php echo $button_cancel; ?></a></div>
    </div>
    <div class="content">
    <!--
    /////////////////////// Modification//////////////////////
    // ID: 1051015        
    // Name: Luu Minh Tan           
    // Class: 10CTT
    // Date created: 24/12/2013
    // Description: Change tab. Add attributes in list-view
    // Date modified: 2/1/2014
    ////////////////////////////////////////////////////////////// 
    -->
    <!-- start LMT -->
      <div id="htabs" class="htabs"><a href="#tab-general"><?php echo $tab_general; ?></a>
        <!-- Delete
        <?php if ($customer_id) { ?>
        
        <a href="#tab-history"><?php echo $tab_history; ?></a>
        <a href="#tab-transaction"><?php echo $tab_transaction; ?></a>
        <a href="#tab-reward"><?php echo $tab_reward; ?></a>
        <?php } ?>
        <a href="#tab-ip"><?php echo $tab_ip; ?></a>
        -->
        </div>
        <!-- end LMT -->
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <div id="tab-general">
          <div id="vtabs" class="vtabs"><a href="#tab-customer"><?php echo $tab_general; ?></a>
            <?php $address_row = 1; ?>
            <?php foreach ($addresses as $address) { ?>
            <a href="#tab-address-<?php echo $address_row; ?>" id="address-<?php echo $address_row; ?>"><?php echo $tab_address . ' ' . $address_row; ?>&nbsp;<img src="view/image/delete.png" alt="" onclick="$('#vtabs a:first').trigger('click'); $('#address-<?php echo $address_row; ?>').remove(); $('#tab-address-<?php echo $address_row; ?>').remove(); return false;" /></a>
            <?php $address_row++; ?>
            <?php } ?>
            <span id="address-add"><?php echo $button_add_address; ?>&nbsp;<img src="view/image/add.png" alt="" onclick="addAddress();" /></span></div>
          <div id="tab-customer" class="vtabs-content">
          <!-- start LMT -->
          <h2 style="border-bottom:none"><?php echo $text_basic_info; ?></h2>
          <div class="content" style="border:1px solid #EEEEEE" >
          <table class="form" style="margin-bottom:0px">
          <!-- end LMT -->
              <tr>
                <td><span class="required">*</span> <?php echo $entry_firstname; ?></td>
                <td><input type="text" name="firstname" value="<?php echo $firstname; ?>" />
                  <?php if ($error_firstname) { ?>
                  <span class="error"><?php echo $error_firstname; ?></span>
                  <?php } ?></td>
              </tr>
              <tr>
                <td><span class="required">*</span> <?php echo $entry_lastname; ?></td>
                <td><input type="text" name="lastname" value="<?php echo $lastname; ?>" />
                  <?php if ($error_lastname) { ?>
                  <span class="error"><?php echo $error_lastname; ?></span>
                  <?php } ?></td>
              </tr>
              <tr>
                <td><span class="required">*</span> <?php echo $entry_date_of_birth; ?></td>
                <td><input type="text" name="date_of_birth" value="<?php echo $date_of_birth; ?>" size="12" class="date" />
                <?php if ($error_date_of_birth) { ?>
                  <span class="error"><?php echo $error_date_of_birth; ?></span>
                  <?php  } ?>
                </td>
              </tr>
              <tr>
                <td><span class="required">*</span> <?php echo $entry_gender; ?></td>
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
              <!-- start LMT --> 
              </table>
              </div>
              <h2 style="border-bottom:none"><?php echo $text_contact; ?></h2>
              <div class="content" style="border:1px solid #EEEEEE" >
              <table class="form" style="margin-bottom:0px">
              <!-- end LMT -->
              <tr>
                <td><span class="required">*</span> <?php echo $entry_email; ?></td>
                <td><input type="text" name="email" value="<?php echo $email; ?>" />
                  <?php if ($error_email) { ?>
                  <span class="error"><?php echo $error_email; ?></span>
                  <?php  } ?></td>
              </tr>
              <tr>
                <td><span class="required">*</span> <?php echo $entry_telephone; ?></td>
                <td><input type="text" name="telephone" value="<?php echo $telephone; ?>" />
                  <?php if ($error_telephone) { ?>
                  <span class="error"><?php echo $error_telephone; ?></span>
                  <?php  } ?></td>
              </tr>
              <!-- start LMT --> 
              </table>
              </div>
              <h2 style="border-bottom:none"><?php echo $text_identity; ?></h2>
              <div class="content" style="border:1px solid #EEEEEE" >
          <table class="form" style="margin-bottom:0px">
              <!-- end LMT -->
              <!-- start LMT -->
              <tr>
                <td><span class="required">*</span> <?php echo $entry_idnum; ?></td>
                <td><input type="text" name="idnum" value="<?php echo $idnum; ?>" />
                  <?php if ($error_idnum) { ?>
                  <span class="error"><?php echo $error_idnum; ?></span>
                  <?php  } ?></td>
              </tr>
              <tr>
                <td><span class="required">*</span> <?php echo $entry_iddate; ?></td>
                <td><input type="text" name="iddate" value="<?php echo $iddate; ?>" size="12" class="date"/>
                <?php if ($error_iddate) { ?>
                  <span class="error"><?php echo $error_iddate; ?></span>
                  <?php  } ?>
                </td>
              </tr>
              <tr>
              <!-- start LMT -->
                <td><span class="required">*</span><?php echo $entry_idlocation; ?></td>
                <td><select name="id_location">
                  <option value=""><?php echo $text_select; ?></option>
                  <?php foreach ($regions as $region) { ?>
                  <?php if ($region['zone_id'] == $id_location) { ?>
                  <option value="<?php echo $region['zone_id']; ?>" selected="selected"><?php echo $region['name']; ?></option>
                  <?php } else { ?>
                  <option value="<?php echo $region['zone_id']; ?>"><?php echo $region['name']; ?></option>
                  <?php } ?>
                  <?php } ?>
                </select>
                <?php if ($error_id_location) { ?>
              <span class="error"><?php echo $error_id_location; ?></span>
            <?php } ?></td>
            <!-- end LMT -->
              </tr>
              <!-- start LMT --> 
              </table>
              </div>
              <h2 style="border-bottom:none"><?php echo $text_university; ?></h2>
              <div class="content" style="border:1px solid #EEEEEE" >
          <table class="form" style="margin-bottom:0px">
              <!-- end LMT -->
              <tr>
                  <td><span class="required">*</span> <?php echo $entry_university; ?></td>
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
                  <td><span class="required">*</span> <?php echo $entry_faculty; ?></td>
                  <td><select name="faculty_id">
                    </select>
                    <?php if ($error_faculty) { ?>
                    <span class="error"><?php echo $error_faculty; ?></span>
                    <?php } ?></td>
                </tr>
                <tr id="studentidblock_head">
                  <td><span class="required">*</span> <?php echo $entry_student_id; ?></td>
                  <td><input type="text" name="student_id" value="<?php echo $student_id; ?>" />
                    <?php if ($error_student_id) { ?>
                    <span class="error"><?php echo $error_student_id; ?></span>
                    <?php } ?></td>
                </tr>
              <!-- end LMT -->
               <!-- start LMT --> 
              </table>
              </div>
              <h2 style="border-bottom:none"><?php echo $text_password; ?></h2>
              <div class="content" style="border:1px solid #EEEEEE" >
          <table class="form" style="margin-bottom:0px">
              <!-- Delete
              <tr>
                <td><?php echo $entry_fax; ?></td>
                <td><input type="text" name="fax" value="<?php echo $fax; ?>" /></td>
              </tr>
              -->
              <!-- end LMT -->
              <tr>
                <td><?php echo $entry_password; ?></td>
                <td><input type="password" name="password" value="<?php echo $password; ?>"  />
                  <?php if ($error_password) { ?>
                  <span class="error"><?php echo $error_password; ?></span>
                  <?php  } ?></td>
              </tr>
              <tr>
                <td><?php echo $entry_confirm; ?></td>
                <td><input type="password" name="confirm" value="<?php echo $confirm; ?>" />
                  <?php if ($error_confirm) { ?>
                  <span class="error"><?php echo $error_confirm; ?></span>
                  <?php  } ?></td>
              </tr>
              <!-- start LMT --> 
              </table>
              </div>
              <h2 style="border-bottom:none"><?php echo $text_campus; ?></h2>
              <div class="content" style="border:1px solid #EEEEEE" >
          <table class="form" style="margin-bottom:0px">
              <tr>
                <td><?php echo $entry_floor; ?></td>
                <td><select name="floor_id">
                    <?php foreach ($floors as $floor) { ?>
                    <?php if ($floor['floor_id'] == $floor_id) { ?>
                    <option value="<?php echo $floor['floor_id']; ?>" selected="selected"><?php echo $floor['floor_name']; ?></option>
                    <?php } else { ?>
                    <option value="<?php echo $floor['floor_id']; ?>"><?php echo $floor['floor_name']; ?></option>
                    <?php } ?>
                    <?php } ?>
                  </select></td>
              </tr>
              <tr>
                <td><?php echo $entry_customer_group; ?></td>
                <td><select name="customer_group_id">
                </select>
                </td>
                <!--
                <td><select name="customer_group_id">
                    <?php foreach ($customer_groups as $customer_group) { ?>
                    <?php if ($customer_group['customer_group_id'] == $customer_group_id) { ?>
                    <option value="<?php echo $customer_group['customer_group_id']; ?>" selected="selected"><?php echo $customer_group['name']; ?></option>
                    <?php } else { ?>
                    <option value="<?php echo $customer_group['customer_group_id']; ?>"><?php echo $customer_group['name']; ?></option>
                    <?php } ?>
                    <?php } ?>
                  </select></td>
                  -->
              </tr>
              <tr>
              <td><?php echo $entry_bed; ?></td>
                <td><select name="bed_id">
                  <option value=""></option>
                  <?php foreach ($beds as $bed) { ?>
                  <?php if ($bed['bed_id'] == $bed_id) { ?>
                  <option value="<?php echo $bed['bed_id']; ?>" selected="selected"><?php echo $bed['name']; ?></option>
                  <?php } else { ?>
                  <option value="<?php echo $bed['bed_id']; ?>"><?php echo $bed['name']; ?></option>
                  <?php } ?>
                  <?php } ?>
                </select></td>
              </tr>
              <!-- end LMT -->
              </table>
              </div>
              <h2 style="border-bottom:none"><?php echo $text_status; ?></h2>
              <div class="content" style="border:1px solid #EEEEEE" >
          <table class="form" style="margin-bottom:0px">
              <tr>
                <td><?php echo $entry_newsletter; ?></td>
                <td><select name="newsletter">
                    <?php if ($newsletter) { ?>
                    <option value="1" selected="selected"><?php echo $text_receive; ?></option>
                    <option value="0"><?php echo $text_not_receive; ?></option>
                    <?php } else { ?>
                    <option value="1"><?php echo $text_receive; ?></option>
                    <option value="0" selected="selected"><?php echo $text_not_receive; ?></option>
                    <?php } ?>
                  </select></td>
              </tr>
              <tr>
                <td><?php echo $entry_status; ?></td>
                <td><select name="status">
                    <?php if ($status) { ?>
                    <option value="1" selected="selected"><?php echo $text_approve; ?></option>
                    <option value="0"><?php echo $text_not_approve; ?></option>
                    <?php } else { ?>
                    <option value="1"><?php echo $text_approve; ?></option>
                    <option value="0" selected="selected"><?php echo $text_not_approve; ?></option>
                    <?php } ?>
                  </select></td>
              </tr>
            </table>
          </div>
          </div>
          <?php $address_row = 1; ?>
          <?php foreach ($addresses as $address) { ?>
          <div id="tab-address-<?php echo $address_row; ?>" class="vtabs-content">
            <input type="hidden" name="address[<?php echo $address_row; ?>][address_id]" value="<?php echo $address['address_id']; ?>" />
            <table class="form">
            <!-- start LMT -->
            <!--
              <tr>
                <td><span class="required">*</span> <?php echo $entry_firstname; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][firstname]" value="<?php echo $address['firstname']; ?>" />
                  <?php if (isset($error_address_firstname[$address_row])) { ?>
                  <span class="error"><?php echo $error_address_firstname[$address_row]; ?></span>
                  <?php } ?></td>
              </tr>
              <tr>
                <td><span class="required">*</span> <?php echo $entry_lastname; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][lastname]" value="<?php echo $address['lastname']; ?>" />
                  <?php if (isset($error_address_lastname[$address_row])) { ?>
                  <span class="error"><?php echo $error_address_lastname[$address_row]; ?></span>
                  <?php } ?></td>
              </tr>
              <tr>
                <td><?php echo $entry_company; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][company]" value="<?php echo $address['company']; ?>" /></td>
              </tr>
              <tr class="company-id-display">
                <td><?php echo $entry_company_id; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][company_id]" value="<?php echo $address['company_id']; ?>" /></td>
              </tr>
              <tr class="tax-id-display">
                <td><?php echo $entry_tax_id; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][tax_id]" value="<?php echo $address['tax_id']; ?>" />
                  <?php if (isset($error_address_tax_id[$address_row])) { ?>
                  <span class="error"><?php echo $error_address_tax_id[$address_row]; ?></span>
                  <?php } ?></td>
              </tr>
              -->
               <!-- end LMT -->
              <tr>
                <td><span class="required">*</span> <?php echo $entry_address_1; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][address_1]" value="<?php echo $address['address_1']; ?>" />
                  <?php if (isset($error_address_address_1[$address_row])) { ?>
                  <span class="error"><?php echo $error_address_address_1[$address_row]; ?></span>
                  <?php } ?></td>
              </tr>
              <!-- start LMT -->
              <!-- 
              <tr>
                <td><?php echo $entry_address_2; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][address_2]" value="<?php echo $address['address_2']; ?>" /></td>
              </tr>
             
              <tr>
                <td><span class="required">*</span> <?php echo $entry_city; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][city]" value="<?php echo $address['city']; ?>" />
                  <?php if (isset($error_address_city[$address_row])) { ?>
                  <span class="error"><?php echo $error_address_city[$address_row]; ?></span>
                  <?php } ?></td>
              </tr>

              <tr>
                <td><span id="postcode-required<?php echo $address_row; ?>" class="required">*</span> <?php echo $entry_postcode; ?></td>
                <td><input type="text" name="address[<?php echo $address_row; ?>][postcode]" value="<?php echo $address['postcode']; ?>" /></td>
              </tr>
              -->
              <!-- end LMT -->
              <tr>
                <td><span class="required">*</span> <?php echo $entry_country; ?></td>
                <td><select name="address[<?php echo $address_row; ?>][country_id]" onchange="country(this, '<?php echo $address_row; ?>', '<?php echo $address['zone_id']; ?>');">
                    <option value=""><?php echo $text_select; ?></option>
                    <?php foreach ($countries as $country) { ?>
                    <?php if ($country['country_id'] == $address['country_id']) { ?>
                    <option value="<?php echo $country['country_id']; ?>" selected="selected"><?php echo $country['name']; ?></option>
                    <?php } else { ?>
                    <option value="<?php echo $country['country_id']; ?>"><?php echo $country['name']; ?></option>
                    <?php } ?>
                    <?php } ?>
                  </select>
                  <?php if (isset($error_address_country[$address_row])) { ?>
                  <span class="error"><?php echo $error_address_country[$address_row]; ?></span>
                  <?php } ?></td>
              </tr>
              <tr>
                <td><span class="required">*</span> <?php echo $entry_zone; ?></td>
                <td><select name="address[<?php echo $address_row; ?>][zone_id]">
                  </select>
                  <?php if (isset($error_address_zone[$address_row])) { ?>
                  <span class="error"><?php echo $error_address_zone[$address_row]; ?></span>
                  <?php } ?></td>
              </tr>
              <tr>
                <td><?php echo $entry_default; ?></td>
                <td><?php if (($address['address_id'] == $address_id) || !$addresses) { ?>
                  <input type="radio" name="address[<?php echo $address_row; ?>][default]" value="<?php echo $address_row; ?>" checked="checked" /></td>
                <?php } else { ?>
                <input type="radio" name="address[<?php echo $address_row; ?>][default]" value="<?php echo $address_row; ?>" />
                  </td>
                <?php } ?>
              </tr>
            </table>
          </div>
          <?php $address_row++; ?>
          <?php } ?>
        </div>
        <!-- start LMT -->
        <!-- Delete
        <?php if ($customer_id) { ?>
        <div id="tab-history">
          <div id="history"></div>
          <table class="form">
            <tr>
              <td><?php echo $entry_comment; ?></td>
              <td><textarea name="comment" cols="40" rows="8" style="width: 99%;"></textarea></td>
            </tr>
            <tr>
              <td colspan="2" style="text-align: right;"><a id="button-history" class="button"><span><?php echo $button_add_history; ?></span></a></td>
            </tr>
          </table>
        </div>
        <div id="tab-transaction">
          <table class="form">
            <tr>
              <td><?php echo $entry_description; ?></td>
              <td><input type="text" name="description" value="" /></td>
            </tr>
            <tr>
              <td><?php echo $entry_amount; ?></td>
              <td><input type="text" name="amount" value="" /></td>
            </tr>
            <tr>
              <td colspan="2" style="text-align: right;"><a id="button-transaction" class="button" onclick="addTransaction();"><span><?php echo $button_add_transaction; ?></span></a></td>
            </tr>
          </table>
          <div id="transaction"></div>
        </div>
        <div id="tab-reward">
          <table class="form">
            <tr>
              <td><?php echo $entry_description; ?></td>
              <td><input type="text" name="description" value="" /></td>
            </tr>
            <tr>
              <td><?php echo $entry_points; ?></td>
              <td><input type="text" name="points" value="" /></td>
            </tr>
            <tr>
              <td colspan="2" style="text-align: right;"><a id="button-reward" class="button" onclick="addRewardPoints();"><span><?php echo $button_add_reward; ?></span></a></td>
            </tr>
          </table>
          <div id="reward"></div>
        </div>
        <?php } ?>
        <div id="tab-ip">
          <table class="list">
            <thead>
              <tr>
                <td class="left"><?php echo $column_ip; ?></td>
                <td class="right"><?php echo $column_total; ?></td>
                <td class="left"><?php echo $column_date_added; ?></td>
                <td class="right"><?php echo $column_action; ?></td>
              </tr>
            </thead>
            <tbody>
              <?php if ($ips) { ?>
              <?php foreach ($ips as $ip) { ?>
              <tr>
                <td class="left"><a href="http://www.geoiptool.com/en/?IP=<?php echo $ip['ip']; ?>" target="_blank"><?php echo $ip['ip']; ?></a></td>
                <td class="right"><a href="<?php echo $ip['filter_ip']; ?>" target="_blank"><?php echo $ip['total']; ?></a></td>
                <td class="left"><?php echo $ip['date_added']; ?></td>
                <td class="right"><?php if ($ip['ban_ip']) { ?>
                  <b>[</b> <a id="<?php echo str_replace('.', '-', $ip['ip']); ?>" onclick="removeBanIP('<?php echo $ip['ip']; ?>');"><?php echo $text_remove_ban_ip; ?></a> <b>]</b>
                  <?php } else { ?>
                  <b>[</b> <a id="<?php echo str_replace('.', '-', $ip['ip']); ?>" onclick="addBanIP('<?php echo $ip['ip']; ?>');"><?php echo $text_add_ban_ip; ?></a> <b>]</b>
                  <?php } ?></td>
              </tr>
              <?php } ?>
              <?php } else { ?>
              <tr>
                <td class="center" colspan="4"><?php echo $text_no_results; ?></td>
              </tr>
              <?php } ?>
            </tbody>
          </table>
        </div>
        -->
        <!-- end LMT -->
      </form>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
$('select[name=\'customer_group_id\']').live('change', function() {
	var customer_group = [];
	
<?php foreach ($customer_groups as $customer_group) { ?>
	customer_group[<?php echo $customer_group['customer_group_id']; ?>] = [];
	customer_group[<?php echo $customer_group['customer_group_id']; ?>]['company_id_display'] = '<?php echo $customer_group['company_id_display']; ?>';
	customer_group[<?php echo $customer_group['customer_group_id']; ?>]['tax_id_display'] = '<?php echo $customer_group['tax_id_display']; ?>';
<?php } ?>	

	if (customer_group[this.value]) {
		if (customer_group[this.value]['company_id_display'] == '1') {
			$('.company-id-display').show();
		} else {
			$('.company-id-display').hide();
		}
		
		if (customer_group[this.value]['tax_id_display'] == '1') {
			$('.tax-id-display').show();
		} else {
			$('.tax-id-display').hide();
		}
	}
});

$('select[name=\'customer_group_id\']').trigger('change');
//--></script> 
<script type="text/javascript"><!--
function country(element, index, zone_id) {
  if (element.value != '') {
		$.ajax({
			url: 'index.php?route=sale/customer/country&token=<?php echo $token; ?>&country_id=' + element.value,
			dataType: 'json',
			beforeSend: function() {
				$('select[name=\'address[' + index + '][country_id]\']').after('<span class="wait">&nbsp;<img src="view/image/loading.gif" alt="" /></span>');
			},
			complete: function() {
				$('.wait').remove();
			},			
			success: function(json) {
				if (json['postcode_required'] == '1') {
					$('#postcode-required' + index).show();
				} else {
					$('#postcode-required' + index).hide();
				}
				
				html = '<option value=""><?php echo $text_select; ?></option>';
				
				if (json['zone'] != '') {
					for (i = 0; i < json['zone'].length; i++) {
						html += '<option value="' + json['zone'][i]['zone_id'] + '"';
						
						if (json['zone'][i]['zone_id'] == zone_id) {
							html += ' selected="selected"';
						}
		
						html += '>' + json['zone'][i]['name'] + '</option>';
					}
				} else {
					html += '<option value="0"><?php echo $text_none; ?></option>';
				}
				$('select[name=\'address[' + index + '][zone_id]\']').html(html);
				
				<!-- start LMT-->
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
				<!-- end LMT-->
				
				
			},
			error: function(xhr, ajaxOptions, thrownError) {
				alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
			}
		});
	}
}

$('select[name$=\'[country_id]\']').trigger('change');

/////////////////////// Modification//////////////////////
  // ID: 1051015        
  // Name: Luu Minh Tan           
  // Class: 10CTT
  // Date created: 22/12/2013
  // Description: Code get university and check NK high school function 
  // Date modified: 2/1/2014
  ////////////////////////////////////////////////////////////// 
<!-- start LMT -->
// Ajax for select University.......................................
var nkid = '<?php echo $NKUniversity ?>';
$('select[name=\'university_id\']').bind('change', function() {
	$.ajax({
		url: 'index.php?route=sale/customer/childcategory&token=<?php echo $token; ?>&university_id=' + $('select[name=\'university_id\']').val(),
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
	// if($('select[name=\'university_id\']').val() == nkid) {
	// 	var timestamp = +new Date();
	// 	$('tr[id^=\'studentidblock_\']').hide();
	// 	$('input[name=\'student_id\']').val('NK'+ timestamp.toString().substr(0,8));
	// 	$('input[name=\'student_id\']').attr("readonly","readonly");
	// }
	// else{
	// 	$('tr[id^=\'studentidblock_\']').show();
	// 	$('input[name=\'student_id\']').val('');
	// 	$('input[name=\'student_id\']').removeAttr("readonly");
	// }
});

$('select[name=\'university_id\']').trigger('change');


// Ajax for select Floor .......................................
$('select[name=\'floor_id\']').bind('change', function() {
  $.ajax({
    url: 'index.php?route=sale/customer/childfloor&token=<?php echo $token; ?>&floor_id=' + $('select[name=\'floor_id\']').val(),
    dataType: 'json',
    beforeSend: function() {
      $('select[name=\'floor_id\']').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
    },
    complete: function() {
      $('.wait').remove();
    },      
    success: function(json) {
      
      html = '<option value=""></option>';
      if (json) {
        for (i = 0; i < json.length; i++) {
              html += '<option value="' + json[i]['customer_group_id'] + '"';
            
          if (json[i]['customer_group_id'] == '<?php echo $customer_group_id; ?>') {
                html += ' selected="selected"';
            }
  
            html += '>' + json[i]['name'] + '</option>';
        }
      } else {
        html += '<option value="" selected="selected"><?php echo $text_none; ?></option>';
      }
      
      $('select[name=\'customer_group_id\']').html(html);
      
    },
    error: function(xhr, ajaxOptions, thrownError) {
      alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
    }
  });
});

$('select[name=\'floor_id\']').trigger('change');
<!--end LMT-->


//--></script> 
<script type="text/javascript"><!--
var address_row = <?php echo $address_row; ?>;

function addAddress() {	
	html  = '<div id="tab-address-' + address_row + '" class="vtabs-content" style="display: none;">';
	html += '  <input type="hidden" name="address[' + address_row + '][address_id]" value="" />';
	html += '  <table class="form">'; 
	html += '    <tr>';
  // start LMT
  /*
    html += '	   <td><span class="required">*</span> <?php echo $entry_firstname; ?></td>';
    html += '	   <td><input type="text" name="address[' + address_row + '][firstname]" value="" /></td>';
    html += '    </tr>';
    html += '    <tr>';
    html += '      <td><span class="required">*</span> <?php echo $entry_lastname; ?></td>';
    html += '      <td><input type="text" name="address[' + address_row + '][lastname]" value="" /></td>';
    html += '    </tr>';
    html += '    <tr>';
    html += '      <td><?php echo $entry_company; ?></td>';
    html += '      <td><input type="text" name="address[' + address_row + '][company]" value="" /></td>';
    html += '    </tr>';	
    html += '    <tr class="company-id-display">';
    html += '      <td><?php echo $entry_company_id; ?></td>';
    html += '      <td><input type="text" name="address[' + address_row + '][company_id]" value="" /></td>';
    html += '    </tr>';
    html += '    <tr class="tax-id-display">';
    html += '      <td><?php echo $entry_tax_id; ?></td>';
    html += '      <td><input type="text" name="address[' + address_row + '][tax_id]" value="" /></td>';
    html += '    </tr>';	
    */
    // end LMT		
    html += '    <tr>';
    html += '      <td><span class="required">*</span> <?php echo $entry_address_1; ?></td>';
    html += '      <td><input type="text" name="address[' + address_row + '][address_1]" value="" /></td>';
    html += '    </tr>';
    // start LMT 
    /*
    html += '    <tr>';
    html += '      <td><span class="required">*</span><?php echo $entry_address_2; ?></td>';
    html += '      <td><input type="text" name="address[' + address_row + '][address_2]" value="" /></td>';
    html += '    </tr>';
    html += '    <tr style="display:none;">';
    html += '      <td><span class="required">*</span> <?php echo $entry_city; ?></td>';
    html += '      <td><input type="text" name="address[' + address_row + '][city]" value="" /></td>';
    html += '    </tr>';
    html += '    <tr>';
    html += '      <td><span id="postcode-required' + address_row + '" class="required">*</span> <?php echo $entry_postcode; ?></td>';
    html += '      <td><input type="text" name="address[' + address_row + '][postcode]" value="" /></td>';
    html += '    </tr>';
    */
    // end LMT
	html += '    <tr>';
    html += '      <td><span class="required">*</span> <?php echo $entry_country; ?></td>';
    html += '      <td><select name="address[' + address_row + '][country_id]" onchange="country(this, \'' + address_row + '\', \'0\');">';
    html += '         <option value=""><?php echo $text_select; ?></option>';
    <?php foreach ($countries as $country) { ?>
    html += '         <option value="<?php echo $country['country_id']; ?>"><?php echo addslashes($country['name']); ?></option>';
    <?php } ?>
    html += '      </select></td>';
    html += '    </tr>';
    html += '    <tr>';
    html += '      <td><span class="required">*</span> <?php echo $entry_zone; ?></td>';
    html += '      <td><select name="address[' + address_row + '][zone_id]"><option value="false"><?php echo $this->language->get('text_none'); ?></option></select></td>';
    html += '    </tr>';
	html += '    <tr>';
    html += '      <td><?php echo $entry_default; ?></td>';
    html += '      <td><input type="radio" name="address[' + address_row + '][default]" value="1" /></td>';
    html += '    </tr>';
    html += '  </table>';
    html += '</div>';
	
	$('#tab-general').append(html);
	
	$('select[name=\'address[' + address_row + '][country_id]\']').trigger('change');	
	
	$('#address-add').before('<a href="#tab-address-' + address_row + '" id="address-' + address_row + '"><?php echo $tab_address; ?> ' + address_row + '&nbsp;<img src="view/image/delete.png" alt="" onclick="$(\'#vtabs a:first\').trigger(\'click\'); $(\'#address-' + address_row + '\').remove(); $(\'#tab-address-' + address_row + '\').remove(); return false;" /></a>');
		 
	$('.vtabs a').tabs();
	
	$('#address-' + address_row).trigger('click');
	
	address_row++;
}
//--></script> 
<script type="text/javascript"><!--
$('#history .pagination a').live('click', function() {
	$('#history').load(this.href);
	
	return false;
});			

$('#history').load('index.php?route=sale/customer/history&token=<?php echo $token; ?>&customer_id=<?php echo $customer_id; ?>');

$('#button-history').bind('click', function() {
	$.ajax({
		url: 'index.php?route=sale/customer/history&token=<?php echo $token; ?>&customer_id=<?php echo $customer_id; ?>',
		type: 'post',
		dataType: 'html',
		data: 'comment=' + encodeURIComponent($('#tab-history textarea[name=\'comment\']').val()),
		beforeSend: function() {
			$('.success, .warning').remove();
			$('#button-history').attr('disabled', true);
			$('#history').before('<div class="attention"><img src="view/image/loading.gif" alt="" /> <?php echo $text_wait; ?></div>');
		},
		complete: function() {
			$('#button-history').attr('disabled', false);
			$('.attention').remove();
      		$('#tab-history textarea[name=\'comment\']').val('');
		},
		success: function(html) {
			$('#history').html(html);
			
			$('#tab-history input[name=\'comment\']').val('');
		}
	});
});
//--></script> 
<script type="text/javascript"><!--
$('#transaction .pagination a').live('click', function() {
	$('#transaction').load(this.href);
	
	return false;
});			

$('#transaction').load('index.php?route=sale/customer/transaction&token=<?php echo $token; ?>&customer_id=<?php echo $customer_id; ?>');

$('#button-transaction').bind('click', function() {
	$.ajax({
		url: 'index.php?route=sale/customer/transaction&token=<?php echo $token; ?>&customer_id=<?php echo $customer_id; ?>',
		type: 'post',
		dataType: 'html',
		data: 'description=' + encodeURIComponent($('#tab-transaction input[name=\'description\']').val()) + '&amount=' + encodeURIComponent($('#tab-transaction input[name=\'amount\']').val()),
		beforeSend: function() {
			$('.success, .warning').remove();
			$('#button-transaction').attr('disabled', true);
			$('#transaction').before('<div class="attention"><img src="view/image/loading.gif" alt="" /> <?php echo $text_wait; ?></div>');
		},
		complete: function() {
			$('#button-transaction').attr('disabled', false);
			$('.attention').remove();
		},
		success: function(html) {
			$('#transaction').html(html);
			
			$('#tab-transaction input[name=\'amount\']').val('');
			$('#tab-transaction input[name=\'description\']').val('');
		}
	});
});
//--></script> 
<script type="text/javascript"><!--
$('#reward .pagination a').live('click', function() {
	$('#reward').load(this.href);
	
	return false;
});			

$('#reward').load('index.php?route=sale/customer/reward&token=<?php echo $token; ?>&customer_id=<?php echo $customer_id; ?>');

function addRewardPoints() {
	$.ajax({
		url: 'index.php?route=sale/customer/reward&token=<?php echo $token; ?>&customer_id=<?php echo $customer_id; ?>',
		type: 'post',
		dataType: 'html',
		data: 'description=' + encodeURIComponent($('#tab-reward input[name=\'description\']').val()) + '&points=' + encodeURIComponent($('#tab-reward input[name=\'points\']').val()),
		beforeSend: function() {
			$('.success, .warning').remove();
			$('#button-reward').attr('disabled', true);
			$('#reward').before('<div class="attention"><img src="view/image/loading.gif" alt="" /> <?php echo $text_wait; ?></div>');
		},
		complete: function() {
			$('#button-reward').attr('disabled', false);
			$('.attention').remove();
		},
		success: function(html) {
			$('#reward').html(html);
								
			$('#tab-reward input[name=\'points\']').val('');
			$('#tab-reward input[name=\'description\']').val('');
		}
	});
}

function addBanIP(ip) {
	var id = ip.replace(/\./g, '-');
	
	$.ajax({
		url: 'index.php?route=sale/customer/addbanip&token=<?php echo $token; ?>',
		type: 'post',
		dataType: 'json',
		data: 'ip=' + encodeURIComponent(ip),
		beforeSend: function() {
			$('.success, .warning').remove();
			
			$('.box').before('<div class="attention"><img src="view/image/loading.gif" alt="" /> <?php echo $text_wait; ?></div>');		
		},
		complete: function() {
			
		},			
		success: function(json) {
			$('.attention').remove();
			
			if (json['error']) {
				 $('.box').before('<div class="warning" style="display: none;">' + json['error'] + '</div>');
				
				$('.warning').fadeIn('slow');
			}
						
			if (json['success']) {
                $('.box').before('<div class="success" style="display: none;">' + json['success'] + '</div>');
				
				$('.success').fadeIn('slow');
				
				$('#' + id).replaceWith('<a id="' + id + '" onclick="removeBanIP(\'' + ip + '\');"><?php echo $text_remove_ban_ip; ?></a>');
			}
		}
	});	
}

function removeBanIP(ip) {
	var id = ip.replace(/\./g, '-');
	
	$.ajax({
		url: 'index.php?route=sale/customer/removebanip&token=<?php echo $token; ?>',
		type: 'post',
		dataType: 'json',
		data: 'ip=' + encodeURIComponent(ip),
		beforeSend: function() {
			$('.success, .warning').remove();
			
			$('.box').before('<div class="attention"><img src="view/image/loading.gif" alt="" /> <?php echo $text_wait; ?></div>');					
		},	
		success: function(json) {
			$('.attention').remove();
			
			if (json['error']) {
				 $('.box').before('<div class="warning" style="display: none;">' + json['error'] + '</div>');
				
				$('.warning').fadeIn('slow');
			}
			
			if (json['success']) {
				 $('.box').before('<div class="success" style="display: none;">' + json['success'] + '</div>');
				
				$('.success').fadeIn('slow');
				
				$('#' + id).replaceWith('<a id="' + id + '" onclick="addBanIP(\'' + ip + '\');"><?php echo $text_add_ban_ip; ?></a>');
			}
		}
	});	
};
//--></script> 
<script type="text/javascript"><!--
$('.htabs a').tabs();
$('.vtabs a').tabs();
//--></script> 
<!-- start LMT -->
<script type="text/javascript"><!--
$(document).ready(function() {
  $('.date').datepicker({dateFormat: 'dd-mm-yy'});
});
//--></script> 
<!-- end LMT -->
<?php echo $footer; ?>