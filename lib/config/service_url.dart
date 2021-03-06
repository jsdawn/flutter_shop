// 基础路径
const serviceUrl = 'http://v.jspang.com:8088/baixing';
// const serviceUrl = 'https://www.easy-mock.com/mock/5cd94991a8b9c917e15e7f52/shop';

// 接口路径
const servicePath = {
  'homePageContent': serviceUrl + '/wxmini/homePageContent', //商店首页信息
  'homePageBelowContent': serviceUrl + '/wxmini/homePageBelowConten', //商店首页热卖商品
  'getCategory': serviceUrl + '/wxmini/getCategory', //商品类型分类
  'getMallGoods': serviceUrl + '/wxmini/getMallGoods', //商品分类的商品列表
  'getGoodsDetailById': serviceUrl + '/wxmini/getGoodDetailById', //商品详细信息
};
