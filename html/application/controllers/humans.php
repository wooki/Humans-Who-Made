<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Humans extends CI_Controller {

	/**
	 * display the contents of a humans.txt
	 */
	public function index($domainname) {
    
    $this->output->cache(60);
    
		$sql = "SELECT domains.name, humans.discovered, humans.checked, humans.txt ";
		$sql .= "FROM humans INNER JOIN domains ON (domains.id = humans.domain_id) ";
		$sql .= "WHERE domains.name = '".$domainname."' LIMIT 1;";
    
  	$query = $this->db->query($sql);
	  $humans = $query->result();
    $human = $humans[0];
		
		$sql = "SELECT tags.name ";
		$sql .= "FROM tags INNER JOIN domain_tags ON (tags.id = domain_tags.tag_id) ";
		$sql .= "INNER JOIN domains ON (domains.id = domain_tags.domain_id) ";
		$sql .= "WHERE domains.name = '".$domainname."' ORDER BY tags.id DESC LIMIT 15;";
    
  	$query = $this->db->query($sql);
	  $tags = $query->result();
    
    $data = array('active' => 'sites',
                  'title' => $domainname . ' humans.txt file',
						  'description' => $domainname . ' humans.txt file',
						  'human' => $human, 'tags' => $tags);
		
		$this->load->view('header', $data);
		$this->load->view('humans/index', $data);
		$this->load->view('footer', $data);
  }
  
} 

/* End of file humans.php */
/* Location: ./application/controllers/humans.php */