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
