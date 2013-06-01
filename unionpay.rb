require 'openssl'
require 'iconv'
require 'base64'
require 'cgi'
require 'net/http'
require 'uri'
class Unionpay
  GATEWAY="http://test.gnete.com/bin/scripts/OpenVendor/gnete/V34/GetOvOrder.asp"
  ARGS=[:MerId,:OrderNo,:OrderAmount,:CurrCode,:CallBackUrl,:BankCode,:ResultMode,:Reserved01,:Reserved02]
  CONFIG={
    :MerId=>139,
    :OrderNo=>'o',
    :OrderAmount=>1.00,
    :CurrCode=>'CNY',
    :CallBackUrl=>'h',
    :ResultMode=>1,
    :BankCode=>'',
    :Reserved01=>'',
    :Reserved02=>''
  }
  def params_str
    ARGS.map{|e|  e.to_s + "=" + CONFIG[e].to_s}.join("&")
  end
  #对数据进行加密
  def encode_msg
    file=File.read(File.join(File.dirname(__FILE__),'GNETEWEB-TEST.cer'))
    #TODO 长数据加密
    #TODO 非长数据加密
    OpenSSL::X509::Certificate.new(file).public_key.public_encrypt(params_str).unpack('H*').to_s
  end
  def decrypt_msg
   #TODO 解密数据
  end
  #对数据进行签名
  def sign_msg
    f = File.read(File.join(File.dirname(__FILE__),"MERCHANT.pem"))
    r= OpenSSL::PKey::RSA.new(f)
    r.sign(OpenSSL::Digest::Digest.new('sha1WithRSAEncryption'),params_str).unpack('H*').to_s
  end
  def verify
    #TODO 对数据进行验证
  end
  #URL
  def uri
    Unionpay::GATEWAY + '?EncodeMsg=' + u.encode_msg + "&SignMsg=" + u.sign_msg
  end
end
