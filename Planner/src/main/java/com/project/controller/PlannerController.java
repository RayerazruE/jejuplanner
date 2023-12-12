package com.project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.domain.PlannerVO;
import com.project.service.PlannerService;

import jdk.internal.org.jline.utils.Log;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/page/*")
@AllArgsConstructor
public class PlannerController {
	
	// 생성자주입
	@Autowired
	private PlannerService plannerService;
	
	@RequestMapping(value = "/planner", method = {RequestMethod.GET, RequestMethod.POST })
	public void planner() {
		log.info("planner");
		plannerService.selectMarkers();
		log.info("데이터 : "+plannerService.selectMarkers());
	}
	
	@RequestMapping(value = "/insert", method = {RequestMethod.GET, RequestMethod.POST })
	public void insert() {	
		
	}
	
	@RequestMapping(value = "/createPlanner", method = {RequestMethod.GET, RequestMethod.POST })
	public ResponseEntity<Long> createPlanner(@RequestBody PlannerVO plannerVO) {
        try {
            long generatedId = plannerService.createPlanner(plannerVO);
            return ResponseEntity.ok(generatedId);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
	
	@RequestMapping(value = "/showMarkers", method = {RequestMethod.GET, RequestMethod.POST })
	public String showMarkers(Model model) {
		List<PlannerVO> markerList = plannerService.getAllMarkers();
		model.addAttribute("markerList", markerList);
		
		return "page/planner";
	}

}
