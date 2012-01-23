<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Homepage extends CI_Controller {

	/**
	 * Index Page for this controller.
	 */
	public function index() {
		
		$data = array('active' => 'home',
                  'title' => 'Welcome to Humans Who Made',
						  'description' => 'Welcome to Humans Who Made');
		
		$this->load->view('header', $data);
		$this->load->view('homepage', $data);
		$this->load->view('footer', $data);
	}
	
  
  /**
   * About us page
   */
  public function about_us() {
		
    $query = $this->db->query("SELECT COUNT(id) counter FROM domains;");
		foreach ($query->result() as $row) {
			$count_domains = $row->counter;
		}

		$query = $this->db->query("SELECT COUNT(id) counter FROM humans;");
		foreach ($query->result() as $row) {
			$count_humans = $row->counter;
		}
		
    $percent_humans = 0; 
    $percent_domains = 0;
    if ($count_domains > 0) {
      $percent_humans = ($count_humans / $count_domains) * 100;
      $percent_domains = 100 - $percent_humans;
    }
    $chart_data = $this->simpleEncode(array($percent_domains, $percent_humans), 100, 0);
    
		$data = array('active' => 'about-us',
                  'title' => 'About Humans Who Made',
                  'description' => 'About Humans Who Made',
                  'chart_data' => $chart_data,
                  'percent_humans' => $percent_humans,
                  'percent_domains' => $percent_domains,
                  'count_domains' => $count_domains,
                  'count_humans' => $count_humans);
		
		$this->load->view('header', $data);
		$this->load->view('about_us', $data);
		$this->load->view('footer', $data);    
  }
  
  /**
   * About humans.txt
   */
  public function humanstxt() {
		$data = array('active' => 'humans-txt',
                  'title' => 'About humans.txt',
						  'description' => 'About humans.txt');
		
		$this->load->view('header', $data);
		$this->load->view('humanstxt', $data);
		$this->load->view('footer', $data);    
  }
  
	/*
	 * function for doing google chart "Simple Encoding"
	 */
	private function simpleEncode($values, $max = 61, $min = 0){
        $simple_table =
'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        $chardata = 's:';
        $delta = $max - $min;
        $size = (strlen($simple_table)-1);

        foreach($values as $k => $v){
                if($v >= $min && $v <= $max){
                        $chardata .= $simple_table[round($size * ($v - $min) / $delta)];
                }else{
                        $chardata .= '_';
                }
        }
        return($chardata);
	}
}

/* End of file homepage.php */
/* Location: ./application/controllers/homepage.php */