class Session < ApplicationRecord
  validates :email, :password, presence: true
  validates :email, :token, uniqueness: true
  validate :email_and_password_work

  before_save :generate_token, if: :password_changed?

  def generate_token
    self.token = SecureRandom.base64(32)
  end

  def active_jobs
    parse_jobs(get('/dashboard/active.json'))
  end

  def closed_jobs
    parse_jobs(get('/dashboard/closed.json'))
  end

  def job(job_url)
    parse_job(get(job_url + '.json'))
  end

  def search_candidates(query, page = nil)
    page = [page.to_i, 1].max
    parse_candidates(
      get("/candidates.json?search=#{CGI.escape(query)}&page=#{page}")[:webpros]
    )
  end

  def candidate_applications(candidate_id)
    parse_candidate_applications(
      get("/candidates/#{candidate_id}/applications.json")[:job_applications]
    )
  end

  private

  def parse_job(gob_job)
    iteration = gob_job[:job_iteration]
    job = iteration[:job]
    iteration.slice(
      :active, :url
    ).merge(
      job.slice(
        :title,
        :min_salary, :max_salary,
        :remote, :city, :country,
        :category_name, :tags, :perks, :modality, :seniority,
        :functions, :functions_headline,
        :benefits, :benefits_headline,
        :desirable, :desirable_headline,
        :unpublished
      ).merge(
        public_url: job[:url],
        company_public_url: job[:company_profile],
        company_name: job[:company]
      )
    ).merge(
      {
        phases: parse_phases(iteration[:phases])
      }
    )
  end

  def parse_phases(phases)
    phases.sort_by { |phase| phase[:position] }. map do |phase|
      phase.slice(
        :position, :title, :kind,
        :job_applications_count, :job_applications_url
      )
    end
  end

  def parse_jobs(gob_jobs)
    gob_jobs[:job_iterations].map do |job_iteration|
      {url: job_iteration[:url], title: job_iteration[:job][:title]}
    end
  end

  def parse_candidates(candidates)
    candidates.map do |candidate|
      parse_candidate(candidate)
    end
  end

  def parse_candidate(candidate)
    candidate.slice(
      :id, :firstname, :name, :email, :description, :avatar,
      :country_name,
      :linkedin_link, :github_link, :cv_link, :stackoverflow_link,
      :portfolio_link, :twitter_link
    )
  end

  def parse_candidate_applications(candidate_applications)
    candidate_applications.map do |candidate_application|
      parse_candidate_application(candidate_application)
    end
  end

  def parse_candidate_application(candidate_application)
    candidate_application.slice(
      :id, :url, :job_title, :phase_title,
      :sent_at, :sent_at_full,
      :messages_count, :notes_count,
      :discard_reason
    )es
  end

  def email_and_password_work
    get('/dashboard.json')
  rescue RestClient::ExceptionWithResponse => e
    errors.add(:password, "Invalid email or password")
    Rails.logger.error("Unexpected response: #{e.response}")
  end

  def get(path, params = {})
    response = RestClient.get(
      "https://www.getonbrd.com" + path,
      params.merge(cookies: cookies)
    )
    JSON.parse(response, symbolize_names: true)
  end

  def cookies
    @cookies ||= cookies_from_email_and_password
  end

  def cookies_from_email_and_password
    response = RestClient.get('https://www.getonbrd.com/members/auth/login')
    page = Nokogiri::HTML(response.body)
    csrf_token = page.css('meta[name=csrf-token]').first['content']
    response = RestClient.post(
      'https://www.getonbrd.com/members/auth/login',
      {
        authenticity_token: csrf_token,
        team_member: {
          email: email,
          password: password,
        }
      },
      {cookies: response.cookies}
    )
    raise RestClient::ExceptionWithResponse.new(response)
  rescue RestClient::Found => e
    return e.response.cookies
  end
end

