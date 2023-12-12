package com.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.domain.PlannerVO;
import com.project.mapper.PlannerMapper;

import lombok.Setter;

@Service
public class PlannerServiceImpl implements PlannerService {

	@Setter(onMethod_ = @Autowired)
	private PlannerMapper mapper;

	//전체셀렉트
	@Override
	public List<PlannerVO> selectMarkers() {
		return mapper.selectMarkers();
	}
	
	//단일셀렉트
	public PlannerVO selectMarker(PlannerVO planner) {
		return mapper.selectMarker(planner);
	}
	
	
	//인서트
	@Override
	public long insertMarker(PlannerVO planner) {
		return 1;
	}
	
	//업데이트
	//델리트
	
	//마커아이디부여
	 @Override
	    public long createPlanner(PlannerVO plannerVO) {
	        mapper.insertPlanner(plannerVO);
	        return plannerVO.getMarker_id(); // 생성된 아이디 반환
	    }
	 
	//좌측박스관리
	@Override
	public List<PlannerVO> getAllMarkers() {
		return mapper.getAllMarkers();
	}
	 
	 
}
