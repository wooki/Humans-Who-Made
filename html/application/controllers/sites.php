<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Sites extends CI_Controller {

	/**
	 * List sites with humans.txt
	 */
	public function index() {
    
    $this->output->cache(60);
    
		$sql = "SELECT domains.name, humans.id, domains.title FROM humans INNER JOIN domains ON (domains.id = humans.domain_id) ORDER BY domains.name;";
    
  	$query = $this->db->query($sql);
	  $domains = $query->result();
    
    $data = array('active' => 'sites',
                  'title' => 'Websites with humans.txt for Humans Who Made',
						  'description' => 'Websites with humans.txt for Humans Who Made',
						  'domains' => $domains);
		
		$this->load->view('header', $data);
		$this->load->view('sites/sites', $data);
		$this->load->view('footer', $data);
  }
  
  /**
	 * List sites with humans.txt for the specified tag
	 */
	public function tag($tagname) {
    
		$this->output->cache(60);
    
		$tagname = urldecode($tagname);
		
    $sql = "SELECT domains.name ";
    $sql .= "FROM domains INNER JOIN domain_tags ON (domains.id = domain_tags.domain_id) ";
    $sql .= "INNER JOIN tags ON (domain_tags.tag_id = tags.id) ";
    $sql .= "INNER JOIN humans ON (domains.id = humans.domain_id) ";
    $sql .= "WHERE tags.name = ".$this->db->escape($tagname)." ORDER BY domains.name;";
    
  	$query = $this->db->query($sql);
	  $domains = $query->result();
    
    $data = array('active' => 'tags',
                  'title' => 'Websites for '.$tagname.' with humans.txt for Humans Who Made',
						  'description' => 'Websites for '.$tagname.' with humans.txt for Humans Who Made',
						  'domains' => $domains,
							'tagname' => $tagname);
		
		$this->load->view('header', $data);
		$this->load->view('sites/tag', $data);
		$this->load->view('footer', $data);
  }
  
  
} 

/* End of file tags.php */
/* Location: ./application/controllers/tags.php */
