using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace HelloWorlApi.Controllers
{
    [RoutePrefix("api/helloworld")]
    public class HelloWorldController : ApiController
    {
        [HttpGet]
        [Route("")]
        public string Get()
        {
            return "Hello, World !";
        }
    }
}
