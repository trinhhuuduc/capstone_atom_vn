<?php if (count($languages) > 1) { ?>
<form  id="formlang" action="<?php echo $action; ?>" method="post" enctype="multipart/form-data">
  <div id="language">
  <div class="title">Ngôn ngữ<!-- <?php echo $text_language; ?>--></div>   
  <div class="styled-select">         
	  <select id="langbox" onchange="$('input[name=\'language_code\']').attr('value', this.value).submit(); $('#formlang').submit();">
			  <?php foreach ($languages as $language) { ?>
				  <option id="<?php echo $language['code']; ?>" value="<?php echo $language['code'];?>" <?php if ($language['code'] == $language_code) echo("selected='selected'") ?> ><?php echo $language['code']; ?></option>
			  <?php } ?>
	  </select>
	  <input type="hidden" name="language_code" value="" />
	  <input type="hidden" name="redirect" value="<?php echo $redirect; ?>" />
  </div>
  </div>
</form>
<?php } ?>
<script type="text/javascript">
$(function () {
	$("#langbox").selectbox();
});
</script>