export type Tag = {
  id: string;
  name: string;
};

export type Project = {
  id: string;
  title: string;
  description: string;
  tags: Tag[];
  coverImageURL: string;
  overviewBody: string;
};
