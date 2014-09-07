require 'uri'
require 'net/http'
require 'rubygems'
require 'ostruct'
require 'date'
require 'time'
require 'active_support'
require 'singleton' 

class Risepay

	attr_accessor :UserName, :Password, :url, :defFileds, :info, :RespMSG, :formData, :instance

	def initialize(user,pass)
		@UserName = user;
		@Password = pass;
		@defFileds = ['TransType', 'NameOnCard','CardNum','ExpDate','Amount','CVNum','InvNum',
                               'Zip','Street', 'MagData', 'Amount','PNRef'];
    
    	@formData = [];
    	@url ="https://gateway1.risepay.com/ws/transact.asmx/ProcessCreditCard"
    	@amountFields = ['Amount', 'TipAmt', 'TaxAmt'];

	end 	



	def getGatewayUrl()
		
		return @url 
	end

	def setGatewayUrl(url)
		@url = url
	end

	def getDefFileds

		return @defFileds
	end


	def getRequest
		return @entire= {"UserName"=> "JhonnDev",
			"Password"=> "U0H464z4",
			"TransType"=> "SALE",
			'NameOnCard'=> "Jhonny",
			'CardNum'=>"5149612222222229",
			'ExpDate'=>"1214",
			'Amount'=>"10",
			"MagData"=> "",
			"PNRef"=> "",
			"ExtData"=>'',
			'CVNum'=>"734",
			'InvNum'=>"ABD42",
			'Zip'=>"36124",
			'Street'=>"Gran vio 25"
		}

	end	

	def stringStartsWith(haystack, needle)

		haystack.index(needle)=== 0
	end;
=begin

	def hash_to_query(hash)
	  return URI.encode(hash.map{|k,v| "#{k}=#{v}"}.join("&"))
	end
=end
	def getInstance
		return @instance
	end

	def get_gateway_url
		self.url;
	end;

	def amountConver(num)
		amount = number_to_currency(num, :precision => 2)
		return amount
	end;


	def prepare()
		@data = {
			"UserName" =>@UserName,
			"Password" =>@Password,
			"ExtData"  =>''
		}

		#fix amounts
		

		#Construct ExtData
		@formData.each do |f , value|
			if (@defFileds).include? f
			 	 @data['ExtData']+= "<#{f}>#{value}</#{f}>";
				 @formData.delete(f)
			else
				@data[f] = value;
			
			end
		end

		# set defaults fields
		@defFileds.each do |f|
			if @data[f] == 	nil
			 	@data[f] = '';
			end 
		end

		return @data	
	end

	def sale(opt = null)
		if opt
			@formData = opt
		end
		@formData["UserName"] = @UserName
		@formData["Password"] = @Password
		@formData["MagData"] = ""
		@formData["PNRef"] = ""
		@formData["ExtData"]=""
		@formData["TransType"]="Sale"

		return post(@formData)

	end


	def auth(opt = null)

	    if opt
			@formData = opt
		end

		@formData["UserName"] = @UserName
		@formData["Password"] = @Password
		@formData["MagData"] = ""
		@formData["PNRef"] = ""
		@formData["ExtData"]=""
		@formData["TransType"]="Auth"

		return post(@formData)

	end

	def returnTrans(opt = null)

		if opt
			@formData = opt
		end

		@formData["UserName"] = @UserName
		@formData["Password"] = @Password
		@formData["MagData"] = ""
		#@formData["PNRef"] = "242123"
		@formData["ExtData"]=""
		@formData["TransType"]="Return"

		return post(@formData)
	end
		

	def void(opt = null)

		if opt
			@formData = opt
		end

		@formData["UserName"] = @UserName
		@formData["Password"] = @Password
		@formData["MagData"] = ""
		#@formData["PNRef"] = "242123"
		@formData["ExtData"]=""
		@formData["TransType"]="VOID"

		return post(@formData)

	end

	def capture(opt = null)

		if opt
			@formData = opt
		end

		@formData["UserName"] = @UserName
		@formData["Password"] = @Password
		@formData["MagData"] = ""
		#@formData["PNRef"] = "242123"
		@formData["ExtData"]=""
		@formData["TransType"]="FORCE"

		return post(@formData)

	end

	def convertResponde(xml)


	end

	def post(opts)
	#data


	uri = URI.parse("https://gateway1.risepay.com/ws/transact.asmx/ProcessCreditCard")


    http = Net::HTTP.new(uri.host, uri.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = (uri.scheme == "https")
    request = Net::HTTP::Post.new(uri.request_uri)

    request.set_form_data(opts);
    #request.add_field("Content-Type", "application/x-www-form-urlencoded")

    response = http.request(request)
    xml= response.body
    session = Hash.from_xml(xml)
    resi = session['Response']
		return resi['RespMSG']  

	end



end
