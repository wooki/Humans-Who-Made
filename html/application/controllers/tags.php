<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tags extends CI_Controller {

	/**
	 * load all tags
	 */
	public function index() {
    
    $countuses = "SELECT tags.name name, ROUND(SQRT(count(domain_tags.id)), 0) uses ";
    $countuses .= "FROM tags INNER JOIN domain_tags ON (tags.id = domain_tags.tag_id) ";
    $countuses .= "INNER JOIN domains ON (domain_tags.domain_id = domains.id) ";
    $countuses .= "INNER JOIN humans ON (domains.id = humans.domain_id) ";
    $countuses .= "GROUP BY domain_tags.tag_id";
    
    $sql = "SELECT tgs.* FROM (";
    $sql = $sql.$countuses;
    $sql = $sql.") tgs ORDER BY tgs.uses LIMIT 500;";
    
  	$query = $this->db->query($sql);
	  $tags = $query->result();
    shuffle($tags);
    
    $sql = "SELECT MAX(tgs.uses) counter FROM (";
    $sql = $sql.$countuses;
    $sql = $sql.") tgs;";
    $query = $this->db->query($sql);
	  foreach ($query->result() as $row) {
			$max_uses = $row->counter;
		}
    
    $data = array('active' => 'tags',
                  'title' => 'Tags for Humans Who Made',
						  'description' => 'Tags for Humans Who Made',
						  'tags' => $tags,
              'max_uses' => $max_uses);
		
		$this->load->view('header', $data);
		$this->load->view('tags', $data);
		$this->load->view('footer', $data);
  }
  
  
} 

/* End of file tags.php */
/* Location: ./application/controllers/tags.php */