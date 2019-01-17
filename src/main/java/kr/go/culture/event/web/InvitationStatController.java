package kr.go.culture.event.web;

import javax.annotation.Resource;

import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/event/invitation/stat")
@Controller
public class InvitationStatController {

	private static final Logger logger = LoggerFactory.getLogger(InvitationStatController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

}