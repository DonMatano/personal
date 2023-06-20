export type Tag = {
  id: string;
  name: string;
};

export type Image = {
  url: string;
  caption: string;
}

export type Project = {
  id: string;
  title: string;
  description: string;
  tags: Tag[];
  images: Image[];
  coverImageURL: string;
  overviewBody: string;
  githubLinkURL: string;
  demoLinkURL: string;
};

export type Work = {
  id: string;
  companyName: string;
  companyLogoURL: string;
  companyWebsiteURL: string;
  position: string;
  startDate: string;
  endDate?: string;
  isCurrentJob: boolean;
  description: string;
  responsibilities: string[];
  techsUsed: string[];
};

