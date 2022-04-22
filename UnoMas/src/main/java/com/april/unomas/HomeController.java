package com.april.unomas;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "index";
		
	}
	
	// customerCenter
	@RequestMapping(value = "/contact")
	public String contact() {
		return "customerCenter/contact";
	}
	@RequestMapping(value = "/faq")
	public String faq() {
		return "customerCenter/faq";
	}
	
	// member
	@RequestMapping(value = "/login")
	public String login() {
		return "member/login";
	}
	@RequestMapping(value = "/register")
	public String register() {
		return "member/register";
	}
	
	// product
	@RequestMapping(value = "/check-out")
	public String checkout() {
		return "product/check-out";
	}
	@RequestMapping(value = "/product")
	public String product() {
		return "product/product";
	}
	@RequestMapping(value = "/shop")
	public String shop() {
		return "product/shop";
	}
	@RequestMapping(value = "/shopping-cart")
	public String cart() {
		return "product/shopping-cart";
	}
	
	
	@RequestMapping(value = "/index")
	public String index() {
		return "index";
	}


}
