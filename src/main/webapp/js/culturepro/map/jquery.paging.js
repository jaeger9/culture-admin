/*******************************************************************************
 * jQuery Paging 0.1.7 by composite (ukjinplant@msn.com)
 * http://composite.tistory.com This project licensed under a MIT License.
 ******************************************************************************/
;
(function($) {
	// default properties.
	var a = /a/i, defs = {
		item : 'a',
		next : '[&gt;]',
		prev : '[&lt;]',
		first : '[&lt;&lt;]',
		last : '[&gt;&gt;]',
		firstClass: 'first',
		prevClass: 'prev',
		nextClass: 'next',
		lastClass: 'last',
		format : '{0}',
		itemClass : 'paging-item',
		sideClass : 'paging-side',
		itemCurrent : 'on',
		disabledClass: 'disabled',
		length : 10,
		max : 1,
		current : 1,
		append : false,
		href : '#{0}',
		event : true
	}, format = function(str) {
		var arg = arguments;
		return str.replace(/\{(\d+)\}/g, function(m, d) {
			if (+d < 0)
				return m;
			else
				return arg[+d + 1] || "";
		});
	}, item, make = function(op, page, cls, str) {
		item = document.createElement(op.item);
		item.className = cls;
		
		var appender;
		
		if ((cls.indexOf("first") == 0) || (cls.indexOf("prev") == 0) || (cls.indexOf("next") == 0) || (cls.indexOf("last") == 0)) {
			item.innerHTML = "<span></span>" + format(str, page, op.length, op.start, op.end, op.start - 1, op.end + 1, op.max); 
			appender = op.origin;
		} else {
			item.innerHTML = format(str, page, op.length, op.start, op.end, op.start - 1, op.end + 1, op.max); 
			appender = "span.plistspan";
		}
		
		
//		if (a.test(op.item))
//			item.href = format(op.href, page);
		
		
		if (a.test(op.item) && cls.indexOf(defs.disabledClass) < 0) {
			if (op.href != "") {
				item.href = format(op.href, page);
			} else {
				$(item).removeAttr("href");
				$(item).css("cursor", "pointer");
			}
		}
		
		if (op.event) {
			if (cls.indexOf(defs.disabledClass) < 0) {
				$(item).bind('click', function(e) {
					var fired = true;
					if ($.isFunction(op.onclick))
						fired = op.onclick.call(item, e, page, op);
					if (fired == undefined || fired)
						op.origin.paging($.extend({}, op, {
							current : page
						}));
					return fired;
				}).appendTo(appender);
			} else {
				$(item).appendTo(appender);
			}
			// bind event for each elements.
				
			var ev = 'on';
			switch (str) {
			case op.prev:
				ev += 'prev';
				break;
			case op.next:
				ev += 'next';
				break;
			case op.first:
				ev += 'first';
				break;
			case op.last:
				ev += 'last';
				break;
			default:
				ev += 'item';
				break;
			}
			if ($.isFunction(op[ev]))
				op[ev].call(item, page, op);
		}
		return item;
	};

	$.fn.paging = function(op) {
		op = $.extend({
			origin : this
		}, defs, op || {});
		this.html('');
		if (op.max < 1)
			op.max = 1;
		if (op.current < 1)
			op.current = 1;
		op.start = Math.floor((op.current - 1) / op.length) * op.length + 1;
		op.end = op.start - 1 + op.length;
		if (op.end > op.max)
			op.end = op.max;
		if (!op.append)
			this.empty();
		
		// prev button
//		if (op.current > op.length) {
//			if (op.first !== false)
//				make(op, 1, op.sideClass, op.first);
//			make(op, op.start - 1, op.sideClass, op.prev);
//		}
		
		if (op.first != "") {
			make(op, 1, op.firstClass + (op.current > op.length && op.first !== false ? "" : " " + op.disabledClass), op.first);
		}
		make(op, (op.current > op.length) ? op.start - 1 : 1, op.prevClass + (op.current > op.length ? "" : " " + op.disabledClass), op.prev);
		
		// pages button
		var spanItem = document.createElement("span");
		spanItem.className = "plistspan";
		$(spanItem).appendTo(op.origin);
		for (var i = op.start; i <= op.end; i++) {
			make(op, i, op.itemClass + (i == op.current ? ' ' + op.itemCurrent : ''), op.format);
		}
		
		// next button
//		if (op.current <= Math.floor(op.max / op.length) * op.length) {
//			make(op, op.end + 1, op.sideClass, op.next);
//			if (op.last !== false)
//				make(op, op.max, op.sideClass, op.last);
//		}
		
		make(op, (op.sideClass + (op.current <= Math.floor((op.max - 1) / op.length) * op.length) ? op.end + 1 : op.max), op.nextClass + (op.current <= Math.floor((op.max - 1) / op.length) * op.length ? "" : " " + op.disabledClass), op.next);
		if (op.last != "") {
			make(op, op.max, op.lastClass + (op.current <= Math.floor((op.max - 1) / op.length) * op.length && op.last !== false ? "" : " " + op.disabledClass), op.last);
		}

		// last button
	};
})(jQuery);