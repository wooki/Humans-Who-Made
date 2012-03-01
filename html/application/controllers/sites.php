<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Sites extends CI_Controller {

	/**
	 * List sites with humans.txt
	 */
	public function index() {
    
    #$this->output->cache(5);
    
		// sql to get the number of rows
		$sql = "SELECT COUNT(id) total FROM (SELECT MAX(domains.id) id FROM humans INNER JOIN domains ON (domains.id = humans.domain_id) GROUP BY domains.title, humans.txt) somealias;";
		$query = $this->db->query($sql);
	  $count_humans = $query->result();
    $total_humans = $count_humans[0]->total;

		// set the pagination up
		$this->load->library('pagination');
    $config['base_url'] = base_url().'sites/page/';
		$config['uri_segment'] = 3;
		$config['use_page_numbers'] = TRUE;
    $config['total_rows'] = $total_humans;
    $config['per_page'] = 10;
		$config['num_links'] = 10;
		$config['full_tag_open'] = '<div class="pagination"><ul>';
		$config['full_tag_close'] = '</ul></div>';
		$config['first_link'] = false;
		$config['last_link'] = false;
		$config['first_tag_open'] = '<li>';
		$config['first_tag_close'] = '</li>';
		$config['prev_link'] = '&larr; Previous';
		$config['prev_tag_open'] = '<li class="prev">';
		$config['prev_tag_close'] = '</li>';
		$config['next_link'] = 'Next &rarr;';
		$config['next_tag_open'] = '<li>';
		$config['next_tag_close'] = '</li>';
		$config['last_tag_open'] = '<li>';
		$config['last_tag_close'] = '</li>';
		$config['cur_tag_open'] =  '<li class="active"><a href="#">';
		$config['cur_tag_close'] = '</a></li>';
		$config['num_tag_open'] = '<li>';
		$config['num_tag_close'] = '</li>';

    $this->pagination->initialize($config);
		
	 	// get the data for current page
		$offset = ($this->uri->segment(3, 1)-1) * $config['per_page'];
		$sql = "SELECT MAX(domains.name) name, MAX(humans.id) id, domains.title, domains.description, humans.txt FROM humans INNER JOIN domains ON (domains.id = humans.domain_id) GROUP BY domains.title, humans.txt LIMIT ".$offset.",".$config['per_page'].";";
		mysql_set_charset("utf8");
  	$query = $this->db->query($sql);
	  $domains = $query->result();
    
    $data = array('active' => 'sites',
                  'title' => 'Websites with humans.txt for Humans Who Made',
						  'description' => 'Websites with humans.txt for Humans Who Made',
						  'domains' => $domains);
		
		$this->load->view('header', $data);
		$this->load->view('sites/humans', $data);
		$this->load->view('footer', $data);
  }
  
  /**
	 * List sites with humans.txt for the specified tag
	 */
	public function tag($tagname) {
    
		$this->output->cache(5);
    
		$tagname = urldecode($tagname);
		
    $sql = "SELECT MAX(domains.name) name ";
    $sql .= "FROM domains INNER JOIN domain_tags ON (domains.id = domain_tags.domain_id) ";
    $sql .= "INNER JOIN tags ON (domain_tags.tag_id = tags.id) ";
    $sql .= "INNER JOIN humans ON (domains.id = humans.domain_id) ";
    $sql .= "WHERE tags.name = ".$this->db->escape($tagname)." GROUP BY domains.title, humans.txt";
    
  	mysql_set_charset("utf8");
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
