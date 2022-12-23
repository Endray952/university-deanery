import styled from "styled-components";

const HeadingWrapper = styled.td`
    width: 100%;
    font-size: 1.2em;
    font-weight: bold;
    text-align: center;
    padding-top: 10px;
    padding-bottom: 10px;
    color: black;
`;

const EditableListItemDelimeter = ({ heading }) => {
    return (
        <tr className="bg-white border-b">
            <HeadingWrapper colSpan="4">
                {heading}
            </HeadingWrapper>
        </tr>
    );
};

export default EditableListItemDelimeter;
