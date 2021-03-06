<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

class ControllerSaleManageWie extends Controller {
	private $error = array();
 	
	public function index() {
		//$this->replaceEachRoomData(5);
		$this->language->load('sale/manage_wie');
 
		$this->document->setTitle($this->language->get('heading_title'));
		
 		$this->load->model('setting/setting');
		$this->data['action'] = $this->url->link('sale/manage_wie', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['import_data'] = $this->url->link('tool/import', 'token=' . $this->session->data['token'], 'SSL');
		
		if (($this->request->server['REQUEST_METHOD'] == 'POST')) {
			$this->model_setting_setting->editSetting('manage_wie', $this->request->post);		
			
			$this->session->data['success'] = $this->language->get('text_success');
			
			$this->redirect($this->url->link('sale/manage_wie', 'token=' . $this->session->data['token'], 'SSL'));
		}
		
		$this->load->model('sale/manage_wie');
		
		$this->getList();
	}

	protected function getList() {
		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'cg.name';
		}
		 
		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'ASC';
		}
		
		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}
		
		$url = '';
		
		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}	
		
		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}
			
  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('sale/manage_wie', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);
							
		$this->data['insert'] = $this->url->link('sale/manage_wie/insert', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['delete'] = $this->url->link('sale/manage_wie/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');	
	
		$this->data['manage_wies'] = array();

		$data = array(
			'sort'  => $sort,
			'order' => $order,
			'start' => ($page - 1) * $this->config->get('config_admin_limit'),
			'limit' => $this->config->get('config_admin_limit')
		);
		
		$manage_wie_total = $this->model_sale_manage_wie->getTotalCustomerGroups();
		
		$billing_types = array(
			0 => array(
				'value' => 0,
				'text' => $this->language->get('text_electric')
			),
			1 => array(
				'value' => 1,
				'text' => $this->language->get('text_water')
			),
		);
		
		$allmonths = array();
		for($i = 1; $i < 13; $i ++) {
			$allmonths[] = $i;
		}
		
		$alldays = array();
		for($i = 1; $i < 32; $i ++) {
			$alldays[] = $i;
		}
		
		if ($this->config->get('default_deadline_wie')) {
			$this->data['default_deadline_wie'] = $this->config->get('default_deadline_wie');
		} else {
			$this->data['default_deadline_wie'] = 15;
		}
		
		if ($this->config->get('ministryMail')) {
			$this->data['ministryMail'] = $this->config->get('ministryMail');
		} else {
			$this->data['ministryMail'] = 'congtacsinhvien@hcmus.edu.vn';
		}
		
		$allyears = array();
		for($i = date("Y"); $i >2000; $i --) {
			$allyears[] = $i;
		}
		
		$block_id = 1;
		$this->load->model('sale/manage_wie');
		
		$rooms_input = $this->model_sale_manage_wie->getCustomerGroups();
		$floors_input = $this->model_sale_manage_wie->getFloors($block_id);
		
		$cur_year = date('Y');
		$cur_month = date('m');
		
		/*//floors and room
		$block_id = 1;
		$this->load->model('sale/manage_wie');
		$rooms_input = $this->model_sale_manage_wie->getCustomerGroups();
		$floors_input = $this->model_sale_manage_wie->getFloors($block_id);
		
		//get electric and water limit data
		$this->load->model('price/standard');
		$w_standard = $this->model_price_standard->getWaterStandardPrice();
        $e_standard = $this->model_price_standard->getElectricityStandardPrice();
		
		$cur_year = date('Y');
		$cur_month = date('m');
		
		$billing_wie_classified = array();
		
		foreach($floors_input as $floor_idx => $floor) {
			$data = array('floor' => $floor['floor_id']);
			$results = $this->model_sale_manage_wie->getCustomerGroups($data);
			
			foreach ($results as $result) {
				$totalmoney = 0;
				$elec = $this->model_sale_manage_wie->getElectricLogByRoomId($result['customer_group_id']);
				//echo '<br/>dien:<br/>'.print_r($elec);
				if(isset($elec)) {
					$billing_wie_classified[$result['customer_group_id']]['elec'] = $elec;
					if(isset($elec['End']) && isset($elec['Start'])) {
						$e_usage = (int)$elec['End'] - (int)$elec['Start'];
					}
					else {
						$e_usage = 0;
					}
					$billing_wie_classified[$result['customer_group_id']]['elec']['Usage'] = $e_usage;
					$money = $this->model_sale_manage_wie->calculate_money($e_standard, $e_usage);
					$billing_wie_classified[$result['customer_group_id']]['elec']['Money'] = $money;
					$totalmoney += $money;
				}
				
				$water = $this->model_sale_manage_wie->getWaterLogByRoomId($result['customer_group_id']);					
				//echo '<br/>nuoc:<br/>'.print_r($water);
				if(isset($water)) {
					$billing_wie_classified[$result['customer_group_id']]['water'] = $water ;
					if(isset($water['End']) && isset($water['Start'])) {
						$w_usage = (int)$water['End'] - (int)$water['Start'];
					}
					else {
						$w_usage = 0;
					}
					
					$billing_wie_classified[$result['customer_group_id']]['water']['Usage'] = $w_usage;
					$money = $this->model_sale_manage_wie->calculate_money($w_standard, $w_usage);
					$billing_wie_classified[$result['customer_group_id']]['water']['Money'] = $money;
					$totalmoney += $money;
				}
				
				setlocale(LC_MONETARY, 'en_US');
				$billing_wie_classified[$result['customer_group_id']]['totalmoney'] = str_replace('$','',money_format('%.0n',$totalmoney));
				$billing_wie_classified[$result['customer_group_id']]['inword'] = $this->model_sale_manage_wie->convert_number_to_words((int)$totalmoney). ' đồng';
				
				$floors_input[$floor_idx]['rooms'][] = array(
						'customer_group_id' => $result['customer_group_id'],
						'floor_id' => $result['floor_id'],
						'name'              => $result['name'] . (($result['customer_group_id'] == $this->config->get('config_manage_wie_id')) ? $this->language->get('text_default') : null),
						'sort_order'        => $result['sort_order'],
						'selected'          => isset($this->request->post['selected']) && in_array($result['manage_wie_id'], $this->request->post['selected']),
						'room_data'			=> ((isset($billing_wie_classified[$result['customer_group_id']])) ? $billing_wie_classified[$result['customer_group_id']] : null)
					);
			}	
		}
		
		
		$filter_data = array();
		if(isset($this->request->get['filter_floor'])) {
			$filter_data = array('floor' => $this->request->get['filter_floor']);
			$this->data['filter_floor'] = $this->request->get['filter_floor'];
		}
		else {
			$this->data['filter_floor'] = '';
		}
		
		if(isset($this->request->get['filter_room'])) {
			$this->data['filter_room'] = $this->request->get['filter_room'];
		}
		else {
			$this->data['filter_room'] = '';
		}
		
		
		$rooms_filter = $this->model_sale_manage_wie->getCustomerGroups($filter_data);
		$floors_filter = $this->model_sale_manage_wie->getFloors($block_id);
		
		$filtered_floor = $floors_input;
		if(isset($this->request->get['filter_floor'])) {
			$filtered_floor = array();
			foreach($floors_input as $key => $floor) {
				if((int)$floor['floor_id'] == (int)$this->request->get['filter_floor']) {
					$filtered_floor[$key] = $floor;
				}
			}
		}
		if(isset($this->request->get['filter_room'])) {
			$filtered_floor = array();
			foreach($floors_input as $key => $floor) {
				if(isset($floor['rooms'])) {
					foreach($floor['rooms'] as $ridx => $room) {
						if((int)$room['customer_group_id'] == (int)$this->request->get['filter_room']) {
							$filtered_floor[$key] = $floor;
							$filtered_floor[$key]['rooms'] = array();
							$filtered_floor[$key]['rooms'][$ridx] = $room;
						}
					}
				}
			}
		}*/
		
		$this->data['allmonths'] = $allmonths;
		$this->data['allyears'] = $allyears;
		$this->data['alldays'] = $alldays;
		//$this->data['floors_wie'] = $filtered_floor;
		//$this->data['floors_filter'] = $floors_input;
//		$this->data['rooms_filter'] = $rooms_input;
		$this->data['floors_input'] = $floors_input;
		$this->data['rooms_input'] = $rooms_input;
		$this->data['cur_year'] = $cur_year;
		$this->data['cur_month'] = $cur_month;
		$this->data['token'] = $this->session->data['token'];
		
		$this->data['text_print'] = $this->language->get('text_print');
		$this->data['text_popup_mail_header'] = $this->language->get('text_popup_mail_header');
		$this->data['text_popup_print_header'] = $this->language->get('text_popup_print_header');
		$this->data['text_print'] = $this->language->get('text_print');
		$this->data['text_garbage'] = $this->language->get('text_garbage');
		$this->data['text_popup_preview_header'] = $this->language->get('text_popup_preview_header');
		$this->data['text_import_from_file'] = $this->language->get('text_import_from_file');
		$this->data['text_mssv'] = $this->language->get('text_mssv');
		$this->data['text_sname'] = $this->language->get('text_sname');
		$this->data['text_roomlead'] = $this->language->get('text_roomlead');
		$this->data['text_confirm_student'] = $this->language->get('text_confirm_student');
		$this->data['text_no_student'] = $this->language->get('text_no_student');
		$this->data['text_loading_info'] = $this->language->get('text_loading_info');
		$this->data['text_success_charged'] = $this->language->get('text_success_charged');
		$this->data['text_confirm'] = $this->language->get('text_confirm');
		$this->data['text_electric_start'] = $this->language->get('text_electric_start');
		$this->data['text_water_start'] = $this->language->get('text_water_start');
		$this->data['text_deadline'] = $this->language->get('text_deadline');
		$this->data['text_save'] = $this->language->get('text_save');
		$this->data['text_edit'] = $this->language->get('text_edit');
		$this->data['text_tool'] = $this->language->get('text_tool');
		$this->data['text_reason'] = $this->language->get('text_reason');
		$this->data['text_warning'] = $this->language->get('text_warning');
		$this->data['text_error_log'] = $this->language->get('text_error_log');
		$this->data['text_mail'] = $this->language->get('text_mail');
		$this->data['text_mail_monthly'] = $this->language->get('text_mail_monthly');
		
		$this->data['text_green'] = $this->language->get('text_green');
		$this->data['text_red'] = $this->language->get('text_red');
		$this->data['text_confirm'] = $this->language->get('text_confirm');
		$this->data['text_start_num'] = $this->language->get('text_start_num');
		$this->data['text_end_num'] = $this->language->get('text_end_num');
		$this->data['text_paid'] = $this->language->get('text_paid');
		$this->data['text_late'] = $this->language->get('text_late');
		$this->data['text_refresh'] = $this->language->get('text_refresh');
		
		$this->data['text_floor'] = $this->language->get('text_floor');
		$this->data['text_room'] = $this->language->get('text_room');
		$this->data['text_totalmoney'] = $this->language->get('text_totalmoney');
		$this->data['error_input'] = $this->language->get('error_input');
		$this->data['text_success'] = $this->language->get('text_success');
		$this->data['text_title'] = $this->language->get('text_title');
		$this->data['text_start_num_electric'] = $this->language->get('text_start_num_electric');
		$this->data['text_start_num_water'] = $this->language->get('text_start_num_water');
		$this->data['text_usage_elec'] = $this->language->get('text_usage_elec');
		$this->data['text_usage_water'] = $this->language->get('text_usage_water');
		$this->data['text_cost'] = $this->language->get('text_cost');
		$this->data['text_header'] = $this->language->get('text_header');
		$this->data['text_submit'] = $this->language->get('text_submit');
		
		$this->data['text_limit'] = $this->language->get('text_limit');
		$this->data['text_limit_text'] = $this->language->get('text_limit_text');
		$this->data['text_price'] = $this->language->get('text_price');
		$this->data['text_total'] = $this->language->get('text_total');
		
		$this->data['text_view'] = $this->language->get('text_view');
		$this->data['text_add'] = $this->language->get('text_add');
		$this->data['text_edit'] = $this->language->get('text_edit');
		$this->data['text_header_school'] = $this->language->get('text_header_school');
		$this->data['text_electric'] = $this->language->get('text_electric');
		$this->data['text_water'] = $this->language->get('text_water');
		$this->data['text_month'] = $this->language->get('text_month');
		$this->data['text_year'] = $this->language->get('text_year');
		$this->data['text_popup_header'] = $this->language->get('text_popup_header');
		$this->data['text_greeting'] = $this->language->get('text_greeting');
		$this->data['text_select'] = $this->language->get('text_select');

		$this->data['heading_title'] = $this->language->get('heading_title');
		
		$this->data['text_no_results'] = $this->language->get('text_no_results');

		$this->data['column_name'] = $this->language->get('column_name');
		$this->data['column_sort_order'] = $this->language->get('column_sort_order');
		$this->data['column_action'] = $this->language->get('column_action');

		$this->data['button_insert'] = $this->language->get('button_insert');
		$this->data['button_delete'] = $this->language->get('button_delete');
 
 		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}
		
		if (isset($this->session->data['success'])) {
			$this->data['success'] = $this->session->data['success'];
		
			unset($this->session->data['success']);
		} else {
			$this->data['success'] = '';
		}
		
		$url = '';

		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$this->data['sort_name'] = $this->url->link('sale/manage_wie', 'token=' . $this->session->data['token'] . '&sort=cg.name' . $url, 'SSL');
		$this->data['sort_sort_order'] = $this->url->link('sale/manage_wie', 'token=' . $this->session->data['token'] . '&sort=cg.sort_order' . $url, 'SSL');
		
		$url = '';

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}
												
		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}
				
		$pagination = new Pagination();
		$pagination->total = $manage_wie_total;
		$pagination->page = $page;
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text = $this->language->get('text_pagination');
		$pagination->url = $this->url->link('sale/manage_wie', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');
		
		$this->data['pagination'] = $pagination->render();				

		$this->data['sort'] = $sort; 
		$this->data['order'] = $order;

		$this->template = 'sale/manage_wie_list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
 	}
	
	public function filterRoomByFloorView() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$data = array();
		if(isset($this->request->post['floor_id']) && (int)$this->request->post['floor_id'] != -1) {
			$data['filter_floor'] = (int)$this->request->post['floor_id'];
		}
		if(isset($this->request->post['room_id']) && (int)$this->request->post['room_id'] != -1) {
			$data['filter_room'] = (int)$this->request->post['room_id'];
		}
		
		//$json['filter_floor'] = (int)$this->request->post['floor_id'];
		$json['floors_filtered'] = $this->model_sale_manage_wie->getCustomerGroupsView($data);
		
		$this->response->setOutput(json_encode($json));
	}


	// Nguyen Tan Phu code
	// 1051014
/***********************************************************************************************/
	public function getWieStatOneRoom($roomId) {
		
		$this->load->model('sale/manage_wie');
		$data = array();
		$room = null;
		$data['filter_room'] = $roomId;
		$theFloor = $this->model_sale_manage_wie->getCustomerGroupsView($data);

		$theFloor = array_values($theFloor);
		
		if(isset($theFloor[0]["rooms"])) {
			$room = $theFloor[0]["rooms"][0];
			$room["count"] = (int)$this->model_sale_manage_wie->countStudentInRoom($roomId); 
		}
		

		return $room;
	}
	
	public function replaceEachRoomDataForBill($roomId) {
		$this->load->model('catalog/template_email');
		$templateMailData = $this->model_catalog_template_email->getTemplateEmail("mail_3")['description'][1];

		$templateMail = $templateMailData['description'];
		$mailTitle = $templateMailData['name'];
		
		$mailRoom = array();

		$wie_stat = $this->getWieStatOneRoom($roomId);
		if(!is_null($wie_stat)) {
			$room_data_w = $wie_stat["room_data"]["water"];
			$room_data_e = $wie_stat["room_data"]["elec"];
	
			$completeMailTitle = $this->format($mailTitle, $wie_stat["name"]);
			$completeMailBody = $this->format($templateMail, 
				$wie_stat["name"],				//0
				$wie_stat["count"],				//1 so nguoi 
				// Dien
				$room_data_e["Start"],			//2 dau
				$room_data_e["End"],			//3 cuoi
				$room_data_e["Usage"],			//4 tieu thu
				number_format($room_data_e["Money"],0),			//5 thanh tien
				// Nuoc
				$room_data_w["Start"],			//6 dau
				$room_data_w["End"],			//7 cuoi
				$room_data_w["Usage"],			//8 tieu thu
				number_format($room_data_w["Money"],0),			//9 thanh tien
	
	
				// Tong tien
				
				number_format($room_data_e["Money"] + $room_data_w["Money"] + (($wie_stat["room_data"]["garbage"]) ? $wie_stat["room_data"]["garbage"] : 0),0),		//10
				$wie_stat["room_data"]["inword"],					//11
	
				date("m"),									//12
				date("d"),									//13
				date("m"),									//14
				date("Y"),									//15
				((!is_null($wie_stat["room_data"]["garbage"])) ? number_format($wie_stat["room_data"]["garbage"],0) : ''),			//16
				
				"",											// room leader info ?
				""											// deadline ?
			);

			$mailRoom = array("title" => $mailTitle, "body" => $completeMailBody);
		}
		

		return $mailRoom;
	}
	
	public function replaceEachRoomData($roomId) {
		$this->load->model('catalog/template_email');
		$templateMailData = $this->model_catalog_template_email->getTemplateEmail("mail_1")['description'][1];

		$templateMail = $templateMailData['description'];
		$mailTitle = $templateMailData['name'];
		
		$mailRoom = array();

		$wie_stat = $this->getWieStatOneRoom($roomId);
		if(!is_null($wie_stat)) {
			$room_data_w = $wie_stat["room_data"]["water"];
			$room_data_e = $wie_stat["room_data"]["elec"];
	
			$completeMailTitle = $this->format($mailTitle, $wie_stat["name"]);
			$completeMailBody = $this->format($templateMail, 
				$wie_stat["name"],				//0
				$wie_stat["count"],				//1 so nguoi 
				// Dien
				$room_data_e["Start"],			//2 dau
				$room_data_e["End"],			//3 cuoi
				$room_data_e["Usage"],			//4 tieu thu
				number_format($room_data_e["Money"],0),			//5 thanh tien
				// Nuoc
				$room_data_w["Start"],			//6 dau
				$room_data_w["End"],			//7 cuoi
				$room_data_w["Usage"],			//8 tieu thu
				number_format($room_data_w["Money"],0),			//9 thanh tien
	
	
				// Tong tien
				
				number_format($room_data_e["Money"] + $room_data_w["Money"] + (($wie_stat["room_data"]["garbage"]) ? $wie_stat["room_data"]["garbage"] : 0),0),		//10
				$wie_stat["room_data"]["inword"],					//11
	
				date("m"),									//12
				date("d"),									//13
				date("m"),									//14
				date("Y"),									//15
				((!is_null($wie_stat["room_data"]["garbage"])) ? number_format($wie_stat["room_data"]["garbage"],0) : ''),			//16
				
				"",											// room leader info ?
				""											// deadline ?
			);

			$mailRoom = array("title" => $mailTitle, "body" => $completeMailBody);
		}
		

		return $mailRoom;
	}


	public function getWieStats() {		
		$this->load->model('sale/manage_wie');
		//$json['filter_floor'] = (int)$this->request->post['floor_id'];
		$all_data = $this->model_sale_manage_wie->getCustomerGroupsView(null);
		return $this->filterbyElecWater($all_data);
	}

	public function filterbyElecWater($data = array()) {
		$paidRooms_e = array();
		$unpaidRooms_e = array();
		$latePaidRooms_e = array();
		$paidRooms_w = array();
		$unpaidRooms_w = array();
		$latePaidRooms_w = array();

		for ($i=0; $i<count($data); $i++) {
			$eachFloor = $data[$i];
			if (array_key_exists("rooms", $eachFloor)) {
				$roomList = $eachFloor["rooms"];
			} else {
				$roomList = null;
			}
			
			for ($k=0; $k<count($roomList); $k++) {
				$room = $roomList[$k];
				$roomDataCharged_e = $room["room_data"]["elec"]["Charged"];
				$roomDataCharged_w = $room["room_data"]["water"]["Charged"];
				
				if ($roomDataCharged_e == "yes") {
					$paidRooms_e[] = $room["name"];
				} else if ($roomDataCharged_e == "no") {
					$unpaidRooms_e[] = $room["name"];
				} else if ($roomDataCharged_e == "late") {
					$latePaidRooms_e[] = $room["name"];
				}

				if ($roomDataCharged_w == "yes") {
					$paidRooms_w[] = $room["name"];
				} else if ($roomDataCharged_w == "no") {
					$unpaidRooms_w[] = $room["name"];
				} else if ($roomDataCharged_w == "late") {
					$latePaidRooms_w[] = $room["name"];
				}
			}
		}

		// echo "<pre>";
		// print_r($paidRooms_e);
		// print_r($unpaidRooms_e);
		// print_r($latePaidRooms_e);
		// print_r($paidRooms_w);
		// print_r($unpaidRooms_w);
		// print_r($latePaidRooms_w);
		// echo "</pre>";

		$return_data = array();
		$return_data["paid_e"] = $paidRooms_e;
		$return_data["unpaid_e"] = $unpaidRooms_e;
		$return_data["late_paid_e"] = $latePaidRooms_e;
		$return_data["paid_w"] = $paidRooms_w;
		$return_data["unpaid_w"] = $unpaidRooms_w;
		$return_data["late_paid_w"] = $paidRooms_w;

		return $return_data;

	}

	public function replaceMonthlyMailData() {
		$this->load->model('catalog/template_email');
		$templateMailData = $this->model_catalog_template_email->getTemplateEmail("mail_2")['description'][1];
		$templateMail = $templateMailData['description'];
		$mailTitle = $templateMailData['name'];
		$wie_stats = $this->getWieStats();

		$completeMailTitle = $this->format($mailTitle, date("m"));
		$completeMailBody = $this->format($templateMail, 
			count($wie_stats["paid_e"]),				//0
			implode(", ", $wie_stats["paid_e"]),		//1
			count($wie_stats["unpaid_e"]),				//2
			implode(", ", $wie_stats["unpaid_e"]),		//3
			count($wie_stats["late_paid_e"]),			//4
			implode(", ", $wie_stats["late_paid_e"]),	//5

			count($wie_stats["paid_w"]),				//6
			implode(", ", $wie_stats["paid_w"]),		//7
			count($wie_stats["unpaid_w"]),				//8
			implode(", ", $wie_stats["unpaid_w"]),		//9
			count($wie_stats["late_paid_w"]),			//10
			implode(", ", $wie_stats["late_paid_w"]),	//11

			date("m"),									//12
			date("d"),									//13
			date("m"),									//14
			date("Y")									//15
			);


		$mailMinistry = array("title" => $completeMailTitle, "body" => $completeMailBody);
		return $mailMinistry;
	}

	function format() {
	    $args = func_get_args();
	    if (count($args) == 0) {
	        return;
	    }
	    if (count($args) == 1) {
	        return $args[0];
	    }
	    
	    $str = array_shift($args);
	    $str = preg_replace_callback('/\\{(0|[1-9]\\d*)\\}/', create_function('$match', '$args = '.var_export($args, true).'; return isset($args[$match[1]]) ? $args[$match[1]] : $match[0];'), $str);
	    return $str;
	}
/*****************end Nguyen Tan Phu code*****************************************************************/

	public function filterRoomByFloorInput() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$data = array();
		if(isset($this->request->post['floor_id']) && (int)$this->request->post['floor_id'] != -1) {
			$data['floor'] = (int)$this->request->post['floor_id'];
		}
		
		$json['rooms'] = $this->model_sale_manage_wie->getCustomerGroupsForInput($data);
		
		$this->response->setOutput(json_encode($json));
	}	
	
	public function filterRoomByFloorSelView() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$data = array();
		if(isset($this->request->post['floor_id']) && (int)$this->request->post['floor_id'] != -1) {
			$data['floor'] = (int)$this->request->post['floor_id'];
		}
		
		$json['rooms'] = $this->model_sale_manage_wie->getCustomerGroups($data);
		
		$this->response->setOutput(json_encode($json));
	}	
	
	public function filterRoomByRoomIDInput() {
		$json = array();
		
		$rooms = array();
		$this->load->model('sale/manage_wie');
		if(isset($this->request->post['room_id']) && (int)$this->request->post['room_id'] != -1) {
			 $rooms[] = $this->model_sale_manage_wie->getCustomerGroupForInput((int)$this->request->post['room_id']);
		}
		
		$json['rooms'] = $rooms;
		$this->response->setOutput(json_encode($json));
	}
	
	public function inputUsage() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$return_data = $this->model_sale_manage_wie->inputUsage($this->request->post);
		
				
		$json['success'] = $return_data;
		
		$this->response->setOutput(json_encode($json));
	}	
	
	public function confirmRoomElec() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$result = $this->model_sale_manage_wie->confirmRoomElec($this->request->post);
		
				
		$json['success'] = $result;
		
		$this->response->setOutput(json_encode($json));
	}	
	
	public function confirmRoomWater() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$result =  $this->model_sale_manage_wie->confirmRoomWater($this->request->post);
		
				
		$json['success'] = $result;
		
		$this->response->setOutput(json_encode($json));
	}	
	
	public function getBillInfo() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$mailroom = $this->replaceEachRoomDataForBill((int)$this->request->post['room_id']);
		
		$json['bill'] = $mailroom["body"];
		
		$this->response->setOutput(json_encode($json));
	}
	
	public function getStudentIDFromCardID() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		
		$student_info = $this->model_sale_manage_wie->getStudentIDFromCardID($this->request->post['card_id']);
		
		if(!is_null($student_info)) {
			$json['student_info'] = $student_info;
		}
		
		$this->response->setOutput(json_encode($json));
	}
	
	public function charged() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$this->model_sale_manage_wie->elec_charged((int)$this->request->post['room_id']);//charge elec
		$this->model_sale_manage_wie->water_charged((int)$this->request->post['room_id']);//charge water
		
		$mail_to = $this->model_sale_manage_wie->getRoomLeaderEmail((int)$this->request->post['room_id']);
		$mailroom = $this->replaceEachRoomDataForBill((int)$this->request->post['room_id']);
		
		if($mail_to != '' && isset($mailroom["title"])) {
			$mail = new Mail();
			$mail->protocol = $this->config->get('config_mail_protocol');
			$mail->parameter = $this->config->get('config_mail_parameter');
			$mail->hostname = $this->config->get('config_smtp_host');
			$mail->username = $this->config->get('config_smtp_username');
			$mail->password = $this->config->get('config_smtp_password');
			$mail->port = $this->config->get('config_smtp_port');
			$mail->timeout = $this->config->get('config_smtp_timeout');
			$mail->setTo($mail_to);
			$mail->setFrom($this->config->get('config_email'));
			$mail->setSender($this->config->get('config_name'));
			$mail->setSubject($mailroom["title"]);
			$mail->setHTML($mailroom["body"]);
			$mail->send();
			
			
		}
		
		$json['bill'] = $mailroom["body"];
		$json['success'] = 'yes';
		
		$this->response->setOutput(json_encode($json));
	}
	
	/*public function water_charged() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$this->model_sale_manage_wie->water_charged((int)$this->request->post['room_id']);
		
		$json['success'] = 'yes';
		
		$this->response->setOutput(json_encode($json));
	}*/
	
	public function saveEditWie() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$this->model_sale_manage_wie->saveEditWie($this->request->post);
		
		$json['success'] = 'yes';
		
		$this->response->setOutput(json_encode($json));
	}
	
	public function savelog() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$data = array('action' => $this->request->post['action'],
						'reason' => $this->request->post['reason'],
						'factor' => $this->user->getUserName());
						
		$this->model_sale_manage_wie->savelog($data);
		
		$json['success'] = 'yes';
		
		$this->response->setOutput(json_encode($json));
	}
	
	public function sendMailSelectedRooms() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$all = $this->request->post['all'];
		if($all == 1) {
			$rooms = $this->model_sale_manage_wie->getCustomerGroups();
		}
		else {
			$rooms = explode(',',$this->request->post['rooms']);
		}
		
		//$json['test'] =  $rooms;
		
		foreach($rooms as $room) {
			$room_id = 0;
			if($all == 1) {
				$room_id = $room['customer_group_id'];
			}
			else {
				$room_id = $room;
			}
			
			$mail_to = $this->model_sale_manage_wie->getRoomLeaderEmail($room_id);
			$mailMinistry = $this->replaceEachRoomData($room_id);
			
			if($mail_to != '' && isset($mailMinistry["title"])) {
				$json['mailed'][] = $mail_to;
				$mail = new Mail();
				$mail->protocol = $this->config->get('config_mail_protocol');
				$mail->parameter = $this->config->get('config_mail_parameter');
				$mail->hostname = $this->config->get('config_smtp_host');
				$mail->username = $this->config->get('config_smtp_username');
				$mail->password = $this->config->get('config_smtp_password');
				$mail->port = $this->config->get('config_smtp_port');
				$mail->timeout = $this->config->get('config_smtp_timeout');
				$mail->setTo($mail_to);
				$mail->setFrom($this->config->get('config_email'));
				$mail->setSender($this->config->get('config_name'));
				$mail->setSubject($mailMinistry["title"]);
				$mail->setHTML($mailMinistry["body"]);
				$mail->send();
			}
		}
		
		$json['success'] = 'yes';
		
		$this->response->setOutput(json_encode($json));
	}
	
	public function printSelectedRooms() {
		$json = array();
		
		$this->load->model('sale/manage_wie');
		$all = $this->request->post['all'];
		if($all == 1) {
			$rooms = $this->model_sale_manage_wie->getCustomerGroups();
		}
		else {
			$rooms = explode(',',$this->request->post['rooms']);
		}
		
		//$json['test'] =  $rooms;
		$json['bills'] = '';
		foreach($rooms as $room) {
			$room_id = 0;
			if($all == 1) {
				$room_id = $room['customer_group_id'];
			}
			else {
				$room_id = $room;
			}
			
			$bill = $this->replaceEachRoomDataForBill($room_id);
			if($bill) {
				$json['bills'] .= $bill["body"];
			}
		}
		
		$this->response->setOutput(json_encode($json));
	}

	public function sendMailMinistry() {
		$json = array();
		
		$data = array('mail_to' => $this->request->post['mail_to']);
		$mailMinistry = $this->replaceMonthlyMailData();

		$mail = new Mail();
		$mail->protocol = $this->config->get('config_mail_protocol');
		$mail->parameter = $this->config->get('config_mail_parameter');
		$mail->hostname = $this->config->get('config_smtp_host');
		$mail->username = $this->config->get('config_smtp_username');
		$mail->password = $this->config->get('config_smtp_password');
		$mail->port = $this->config->get('config_smtp_port');
		$mail->timeout = $this->config->get('config_smtp_timeout');
		$mail->setTo($data["mail_to"]);
		$mail->setFrom($this->config->get('config_email'));
		$mail->setSender($this->config->get('config_name'));
		$mail->setSubject($mailMinistry["title"]);
		$mail->setHTML($mailMinistry["body"]);
		$mail->send();

		$json['success'] = 'yes';
		
		$this->response->setOutput(json_encode($json));
	}

	public function sendMailOneRoom() {
		$json = array();
		
		$data = array('mail_to' => $this->request->post['mail_to']);
		$mailMinistry = $this->replaceMonthlyMailData();

		$mail = new Mail();
		$mail->protocol = $this->config->get('config_mail_protocol');
		$mail->parameter = $this->config->get('config_mail_parameter');
		$mail->hostname = $this->config->get('config_smtp_host');
		$mail->username = $this->config->get('config_smtp_username');
		$mail->password = $this->config->get('config_smtp_password');
		$mail->port = $this->config->get('config_smtp_port');
		$mail->timeout = $this->config->get('config_smtp_timeout');
		$mail->setTo($data["mail_to"]);
		$mail->setFrom($this->config->get('config_email'));
		$mail->setSender($this->config->get('config_name'));
		$mail->setSubject($mailMinistry["title"]);
		$mail->setHTML($mailMinistry["body"]);
		$mail->send();

		$json['success'] = 'yes';
		
		$this->response->setOutput(json_encode($json));
	}
}
?>