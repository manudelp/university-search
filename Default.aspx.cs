using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Net.Http;

namespace university_search
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false; // Ocultar errores en cada carga de página
        }

        public async Task<string> GetUniversities(string queryType, string queryValue)
        {
            if (string.IsNullOrWhiteSpace(queryType) || string.IsNullOrWhiteSpace(queryValue))
            {
                return null;
            }

            using (HttpClient client = new HttpClient())
            {
                string url = $"http://universities.hipolabs.com/search?{queryType}={queryValue}";
                var response = await client.GetAsync(url);

                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception($"Error fetching data: {response.StatusCode}");
                }

                return await response.Content.ReadAsStringAsync();
            }
        }

        public class University
        {
            public string country { get; set; }
            public string name { get; set; }
            public string alpha_two_code { get; set; }

            [JsonProperty("state-province")]
            public string state { get; set; }

            public List<string> domains { get; set; }
            public List<string> web_pages { get; set; }

            public List<KeyValuePair<string, string>> DomainLinks
            {
                get
                {
                    var links = new List<KeyValuePair<string, string>>();
                    if (domains != null && web_pages != null)
                    {
                        for (int i = 0; i < Math.Min(domains.Count, web_pages.Count); i++)
                        {
                            links.Add(new KeyValuePair<string, string>(domains[i], web_pages[i]));
                        }
                    }
                    return links;
                }
            }
        }

        protected void btnSearchName_Click(object sender, EventArgs e)
        {
            PerformSearch("name", txtName.Text.Trim());
        }

        protected void btnSearchCountry_Click(object sender, EventArgs e)
        {
            PerformSearch("country", txtCountry.Text.Trim());
        }

        private async void PerformSearch(string queryType, string queryValue)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(queryValue))
                {
                    ClearGridView();
                    lblError.Text = "Please enter a search term.";
                    lblError.Visible = true;
                    return;
                }

                string searchResult = await GetUniversities(queryType, queryValue);
                var universities = JsonConvert.DeserializeObject<List<University>>(searchResult);

                if (universities == null || universities.Count == 0)
                {
                    ClearGridView();
                    lblError.Text = "No results found.";
                    lblError.Visible = true;
                }
                else
                {
                    gvUniversities.DataSource = universities;
                    gvUniversities.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = $"An error occurred: {ex.Message}";
                lblError.Visible = true;
            }
        }

        private void ClearGridView()
        {
            gvUniversities.DataSource = null;
            gvUniversities.DataBind();
        }
    }
}
